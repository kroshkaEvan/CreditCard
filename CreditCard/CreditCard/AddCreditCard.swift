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
    @State var creditLimit = ""
    @State var cardNumber = ""
    @State var paymentSystem = "MasterCard"
    @State var month = 1
    @State var year = Calendar.current.component(.year, from: Date())
    @State var firstColor = Color.pink
    @State var secondColor = Color.blue

    let currentYaer = Calendar.current.component(.year, from: Date())
    
    var body: some View {
        NavigationView{
            Form{
                Section(header: Text("Card information")) {
                    TextField("Name",
                              text: $name)
                    TextField("Card number",
                              text: $cardNumber)
                        .keyboardType(.numberPad)
                    TextField("Credit limit",
                              text: $creditLimit)
                        .keyboardType(.numberPad)
                    Picker("Payment system",
                           selection: $paymentSystem) {
                        ForEach(["MasterCard", "Visa", "UnionPay"],
                                id: \.self) { system in
                            Text(String(system)).tag(String(system))
                        }
                    }.pickerStyle(.segmented)
                }
                
                Section(header: Text("Expiration date")) {
                    Picker("Month",
                           selection: $month) {
                        ForEach(1...12,
                                id: \.self) { month in
                            Text(String(month)).tag(String(month))
                        }
                    }
                    Picker("Year",
                           selection: $year) {
                        ForEach(currentYaer...currentYaer+10,
                                id: \.self) { year in
                            Text(String(year)).tag(String(year))
                        }
                    }
                }
                
                Section(header: Text("Card color")) {
                    ColorPicker("Choose your card first color", selection: $firstColor)
                    ColorPicker("Choose your card second color", selection: $secondColor)
                }
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
