//
//  InvoiceMainView.swift
//  CreditCard
//
//  Created by IvanDev on 29.11.23.
//

import SwiftUI

struct InvoiceMainView: View {
    var body: some View {
        GeometryReader {
            let size = $0.size
            Home(size: size)
        }
        .preferredColorScheme(.dark)
    }
}

struct InvoiceMainView_Previews: PreviewProvider {
    static var previews: some View {
        InvoiceMainView()
    }
}
