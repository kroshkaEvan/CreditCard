//
//  AddCreditCard.swift
//  CreditCard
//
//  Created by Эван Крошкин on 17.08.22.
//

import SwiftUI

struct AddCreditCard: View {
    
    let card: Card?
    
    init(card: Card? = nil) {
        self.card = card
        _name = State(initialValue: self.card?.name ?? "")
        _cardNumber = State(initialValue: self.card?.number ?? "")
        if let limit = card?.limit {
            _limit = State(initialValue:String(limit))
        }
        _month = State(initialValue: Int(self.card?.month ?? 1))
        _year = State(initialValue: Int(self.card?.year ?? Int16(currentYaer)))
        _paymentSystem = State(initialValue: self.card?.typeSystem ?? "")
        if let firstData = self.card?.firstColor,
           let secondData = self.card?.secondColor,
           let firstColor = UIColor.color(data: firstData),
           let secondColor = UIColor.color(data: secondData) {
            let first = Color(firstColor)
            let second = Color(secondColor)
            _firstColor = State(initialValue: first)
            _secondColor = State(initialValue: second)
        }
    }
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var name = ""
    @State var limit = ""
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
                              text: $limit)
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
            .navigationTitle(self.card != nil ? self.card?.name ?? ""  : "Add credit card")
            .navigationBarItems(leading: cancelButton,
                                trailing: saveButton)
        }
    }
    
    private var cancelButton: some View{
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            Text("Cancel")
        }
    }
    
    private var saveButton: some View{
        Button {
            let viewContext = CoreDataManager.shared.container.viewContext
//            guard let selfCard = self.card else {return}
            let card = self.card != nil ? self.card! : Card(context: viewContext)
            card.name = self.name
            card.timestamp = Date()
            card.year = Int16(self.year)
            card.month = Int16(self.month)
            card.limit = Int32(self.limit) ?? 0
            card.number = self.cardNumber
            card.firstColor = UIColor(self.firstColor).encode()
            card.secondColor = UIColor(self.secondColor).encode()
            card.typeSystem = self.paymentSystem
            do {
                try viewContext.save()
                presentationMode.wrappedValue.dismiss()
            } catch {
                
            }
        } label: {
            Text("Save")
        }
    }
}

struct AddCreditCard_Previews: PreviewProvider {
    static var previews: some View {
        AddCreditCard()
    }
}
