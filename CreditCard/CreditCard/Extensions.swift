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
