//
//  AddTransactionForm.swift
//  CreditCard
//
//  Created by Эван Крошкин on 25.08.22.
//

import SwiftUI

struct AddTransactionForm: View {
    @Environment(\.presentationMode) private var presentationMode
    
    @State private var name = ""
    @State private var amount = ""
    @State private var data = Date()
    
    @State private var photoData: Data?
    
    @State var shouldShowPhotoPicker = false

    var body: some View {
        NavigationView{
            Form{
                Section(header: Text("Information")) {
                    TextField("Name", text: $name)
                    TextField("Amount", text: $amount)
                    DatePicker("Data", selection: $data, displayedComponents: .date)
                    NavigationLink {
                        Text("Many").navigationTitle("New transaction")
                    } label: {
                        Text("Many to many")
                    }

                    
                }
                
                Section(header: Text("Photo")) {
                    Button {
                        shouldShowPhotoPicker.toggle()
                    } label: {
                        Text("Select photo")
                    }
                    .fullScreenCover(isPresented: $shouldShowPhotoPicker) {
                        PhotoPickerView(photoData: $photoData)
                    }
                    
                    if let data = photoData,
                       let image = UIImage.init(data: data) {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                    }
                }

            }
            .navigationTitle("Add Transaction")
            .navigationBarItems(leading: cancelButton,
                                trailing: saveButton)
        }
    }
    
    struct PhotoPickerView: UIViewControllerRepresentable {
        
        @Binding var photoData: Data?
        
        class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
            
            private let parent: PhotoPickerView
            
            init(parent: PhotoPickerView) {
                self.parent = parent
            }
            func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
                let image = info[.originalImage] as? UIImage
                self.parent.photoData = image?.jpegData(compressionQuality: 0.75)
                picker.dismiss(animated: true)
            }
            
            func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
                picker.dismiss(animated: true)
            }
        }
        
        func makeCoordinator() -> Coordinator {
            return Coordinator(parent: self)
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
        
        func makeUIViewController(context: Context) -> some UIViewController {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = context.coordinator
            return imagePicker
        }
    }
    
    private var saveButton: some View {
        Button {
            
        } label: {
            Text("Save")
        }

    }
    
    private var cancelButton: some View {
        Button {
            
        } label: {
            Text("Cancel")
        }

    }
}

struct AddTransactionForm_Previews: PreviewProvider {
    static var previews: some View {
        AddTransactionForm()
    }
}
