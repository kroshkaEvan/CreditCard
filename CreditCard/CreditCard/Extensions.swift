//
//  Extensions.swift
//  CreditCard
//
//  Created by Эван Крошкин on 18.08.22.
//

import Foundation
import UIKit

extension UIColor {
    class func color(data: Data) -> UIColor?{
        return try?
        NSKeyedUnarchiver
            .unarchiveTopLevelObjectWithData(data) as? UIColor
    }
    
    func encode() -> Data? {
        return try?
        NSKeyedArchiver.archivedData(withRootObject: self,
                                     requiringSecureCoding: false)
    }
}

extension String {
    func chunked(into size: Int) -> [String] {
        var start = startIndex
        var chunks: [String] = []
        while start < endIndex {
            let end = index(start, offsetBy: size, limitedBy: endIndex) ?? endIndex
            chunks.append(String(self[start..<end]))
            start = end
        }
        return chunks
    }
    
    func addingSpacesEveryFourCharacters() -> String {
        return self.enumerated().map { index, character -> String in
            return (index % 4 == 0 && index > 0) ? " \(character)" : "\(character)"
        }.joined()
    }
    
    func convertExpirationDateToDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/yy"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        if let date = dateFormatter.date(from: self) {
            var components = Calendar.current.dateComponents([.year, .month], from: date)
            components.month! += 1
            components.day = 0
            return Calendar.current.date(from: components)
        }
        return Date()
    }
    
    func determineCardType() -> String? {
        guard !self.isEmpty else { return nil }
        
        if let firstTwoDigits = Int(self.prefix(2)), let firstFourDigits = Int(self.prefix(4)),
           (51...55).contains(firstTwoDigits) || (2221...2720).contains(firstFourDigits),
           self.count == 16 {
            return "MasterCard"
        }
        
        if self.starts(with: "4") && (self.count == 13 || self.count == 16 || self.count == 19) {
            return "Visa"
        }
        
        if self.starts(with: "62") && (16...19).contains(self.count) {
            return "UnionPay"
        }
        
        return nil
    }
}

extension Date {
    func convertDateToExpirationDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/yy"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        return dateFormatter.string(from: self)
    }
}
