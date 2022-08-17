//
//  AddCreditCard.swift
//  CreditCard
//
//  Created by Эван Крошкин on 17.08.22.
//

import SwiftUI

struct AddCreditCard: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var name = ""
    
    var body: some View {
        NavigationView{
            Form{
                Text("Add card form")
                
                TextField("Name", text: $name)
            }
                .navigationTitle("Add credit card")
                .navigationBarItems(leading:
                    Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Cancel")
                }))
        }
    }
}

struct AddCreditCard_Previews: PreviewProvider {
    static var previews: some View {
        AddCreditCard()
    }
}
