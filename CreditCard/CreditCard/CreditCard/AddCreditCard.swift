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
        _securityCode = State(initialValue: self.card?.code ?? "")
        _expirationDate = State(initialValue: self.card?.date?.convertDateToExpirationDateString() ?? "")
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
    @State var securityCode = ""
    @State var cardNumber = ""
    @State var firstColor = Color.purple
    @State var secondColor = Color.cyan
    @State var expirationDate: String = ""
    
    private var expirationBinding: Binding<String> {
        Binding(
            get: { self.expirationDate },
            set: { newValue in
                if newValue.count <= 5 {
                    let filtered = newValue.filter { "0123456789".contains($0) }
                    if filtered.count <= 4 {
                        self.expirationDate = filtered.chunked(into: 2).joined(separator: "/")
                    }
                }
            }
        )
    }
    
    let currentYaer = Calendar.current.component(.year, from: Date())
    
    var body: some View {
        VStack{
            HStack {
                VStack {
                    Text("+ Add Cerd")
                        .font(
                            Font.system(size: 20, weight: .bold, design: .monospaced)
                        )
                        .foregroundColor(.white.opacity(0.87))
                        .frame(height: 28, alignment: .topLeading)
                    Text("Add your debit/credit card")
                        .font(Font.system(size: 15, weight: .light, design: .default))
                        .foregroundColor(Color(red: 0.48, green: 0.47, blue: 0.67))
                        .frame(height: 28, alignment: .topLeading)
                }
                .padding()
                VStack {
                    ColorPicker("", selection: $firstColor)
                    ColorPicker("", selection: $secondColor)
                }
                .padding()
            }
            Spacer()
            AddCreditCaedTextField(text: cardNumber,
                                   name: "Card number")
            .keyboardType(.numberPad)
            Spacer()
            AddCreditCaedTextField(text: name,
                                   name: "Card holder name")
            Spacer()
            HStack {
                self.expirationTextField
                Spacer()
                self.securityCodeTextField
            }
            Spacer()
            self.saveButton
            Spacer()
        }
        .background(
            LinearGradient(
                stops: [
                    Gradient.Stop(color: Color(red: 0.19, green: 0.18, blue: 0.41), location: 0.00),
                    Gradient.Stop(color: Color(red: 0.15, green: 0.14, blue: 0.31), location: 1.00),
                ],
                startPoint: UnitPoint(x: 0.08, y: -0.11),
                endPoint: UnitPoint(x: 0.76, y: 0.87)
            )
        )
    }
}

extension AddCreditCard {
    
    var saveButton: some View {
        Button {
            let viewContext = CoreDataManager.shared.container.viewContext
            let card = self.card != nil ? self.card! : Card(context: viewContext)
            card.name = self.name
            card.code = self.securityCode
            card.date = self.expirationDate.convertExpirationDateToDate()
            card.number = self.cardNumber
            card.firstColor = UIColor(self.firstColor).encode()
            card.secondColor = UIColor(self.secondColor).encode()
            do {
                try viewContext.save()
                presentationMode.wrappedValue.dismiss()
            } catch {
                
            }
        } label: {
            Text("Save")
                .foregroundColor(.white.opacity(0.87))
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .background(
                    LinearGradient(
                        stops: [
                            Gradient.Stop(color: Color(red: 0.05, green: 0.65, blue: 0.76), location: 0.00),
                            Gradient.Stop(color: Color(red: 0.05, green: 0.22, blue: 0.78), location: 1.00),
                        ],
                        startPoint: UnitPoint(x: 0.3, y: 0),
                        endPoint: UnitPoint(x: 0.87, y: 1.91)
                    )
                    .cornerRadius(15)
                )
        }
        .padding(.horizontal, 20)
    }
    
    var expirationTextField: some View {
        TextField("Expiration Date",
                  text: expirationBinding)
        .font(
            Font.system(size: 20, weight: .bold, design: .monospaced)
        )
        .foregroundColor(Color(red: 0.48, green: 0.47, blue: 0.67))
        .cornerRadius(15)
        .frame(height: 44)
        .padding(.horizontal, 15)
        .background(Color(red: 0.1, green: 0.09, blue: 0.24).opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .padding([.leading], 20)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(.white.opacity(0.6), lineWidth: 1)
                .padding([.leading], 20))
    }
    
    var securityCodeTextField: some View {
        TextField("Security Code",
                  text: $securityCode)
        .keyboardType(.numberPad)
        .font(
            Font.system(size: 20, weight: .bold, design: .monospaced)
        )
        .foregroundColor(Color(red: 0.48, green: 0.47, blue: 0.67))
        .cornerRadius(15)
        .frame(height: 44)
        .padding(.horizontal, 15)
        .background(Color(red: 0.1, green: 0.09, blue: 0.24).opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .padding([.trailing], 20)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(.white.opacity(0.6), lineWidth: 1)
                .padding([.trailing], 20))
    }
}

struct AddCreditCard_Previews: PreviewProvider {
    static var previews: some View {
        AddCreditCard()
    }
}

struct AddCreditCaedTextField: View {
    @State var text: String
    
    var name: String

    var body: some View {
        TextField(name,
                  text: $text)
        .font(
            Font.system(size: 20, weight: .bold, design: .monospaced)
        )
        .foregroundColor(Color(red: 0.48, green: 0.47, blue: 0.67))
        .cornerRadius(15)
        .frame(height: 44)
        .padding(.horizontal, 15)
        .background(Color(red: 0.1, green: 0.09, blue: 0.24).opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .padding(.horizontal, 20)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(.white.opacity(0.6), lineWidth: 1)
                .padding(.horizontal, 20))
    }
}
