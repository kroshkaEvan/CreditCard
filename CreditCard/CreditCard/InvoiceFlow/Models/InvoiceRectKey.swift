//
//  InvoiceRectKey.swift
//  CreditCard
//
//  Created by IvanDev on 4.12.23.
//

import SwiftUI

struct InvoiceRectKey: PreferenceKey {
    static var defaultValue: [String: Anchor<CGRect>] = [:]
    
    static func reduce(value: inout [String : Anchor<CGRect>], nextValue: () -> [String : Anchor<CGRect>]) {
        value.merge(nextValue()) { $1 }
    }
}
