//
//  FaceDatection.swift
//  CreditCard
//
//  Created by IvanDev on 8.01.24.
//

import SwiftUI
import Vision
import AVFoundation

class CameraManager: NSObject, ObservableObject {
    @Published private var captureSession = AVCaptureSession()
    @Published private var photoOutput = AVCapturePhotoOutput()

    override init() {
        super.init()
        self.setupCamera()
    }
    
    @Published var onPhotoTaken: ((UIImage) -> Void)?

    private func setupCamera() {
        guard let videoDevice = AVCaptureDevice.default(.builtInTrueDepthCamera, for: .video, position: .front),
              let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice),
              captureSession.canAddInput(videoDeviceInput),
              captureSession.canAddOutput(photoOutput) else {
            return
        }
        captureSession.beginConfiguration()
        captureSession.addInput(videoDeviceInput)
        captureSession.addOutput(photoOutput)
        captureSession.commitConfiguration()
        captureSession.startRunning()
    }

    func takePhoto() {
        let photoSettings = AVCapturePhotoSettings()
        
        if photoOutput.isDepthDataDeliverySupported {
            photoOutput.isDepthDataDeliveryEnabled = true
        }
        
        if photoOutput.isDepthDataDeliveryEnabled {
            photoSettings.isDepthDataDeliveryEnabled = true
        }

        photoOutput.capturePhoto(with: photoSettings, delegate: self)
    }
}

extension CameraManager: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation(),
              let image = UIImage(data: imageData) else {
            return
        }
        
        onPhotoTaken?(image)
        processCapturedPhoto(image, depthData: photo.depthData!)
    }

    private func processCapturedPhoto(_ photo: UIImage, depthData: AVDepthData) {
        DepthPhotoAnalyzer().analyzePhoto(photo: photo, depthData: depthData)
    }
}

class DepthPhotoAnalyzer {
    func analyzePhoto(photo: UIImage, depthData: AVDepthData) {
        // Создание и конфигурация запроса Vision для обнаружения лиц
        let request = VNDetectFaceRectanglesRequest { [weak self] request, error in
            guard let results = request.results as? [VNFaceObservation], error == nil else {
                print("Face detection error: \(error?.localizedDescription ?? "")")
                return
            }

            for faceObservation in results {
                self?.analyzeFaceObservation(faceObservation, in: photo, with: depthData)
            }
        }

        // Выполнение запроса Vision
        guard let cgImage = photo.cgImage else { return }
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        try? handler.perform([request])
    }

    private func analyzeFaceObservation(_ observation: VNFaceObservation, in photo: UIImage, with depthData: AVDepthData) {
        let faceBounds = observation.boundingBox
        let depthMap = depthData.depthDataMap

        CVPixelBufferLockBaseAddress(depthMap, .readOnly)
        defer { CVPixelBufferUnlockBaseAddress(depthMap, .readOnly) }

        let width = CVPixelBufferGetWidth(depthMap)
        let height = CVPixelBufferGetHeight(depthMap)
        let rowDataSize = CVPixelBufferGetBytesPerRow(depthMap)

        guard let baseAddress = CVPixelBufferGetBaseAddress(depthMap) else {
            return
        }

        var depthSum: Float = 0
        var depthCount: Int = 0

        for y in stride(from: 0, to: height, by: 1) {
            let rowData = baseAddress.advanced(by: y * rowDataSize)

            for x in stride(from: 0, to: width, by: 1) {
                let pixelOffset = rowData + x * MemoryLayout<Float32>.size
                let depthPixel = pixelOffset.load(as: Float32.self)

                if faceBounds.contains(CGPoint(x: CGFloat(x) / CGFloat(width), y: CGFloat(y) / CGFloat(height))) {
                    depthSum += depthPixel
                    depthCount += 1
                }
            }
        }

        let averageDepth = depthCount > 0 ? depthSum / Float(depthCount) : 0
        print("Average depth of face: \(averageDepth)")
    }

}
