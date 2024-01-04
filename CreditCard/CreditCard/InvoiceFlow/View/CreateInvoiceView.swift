//
//  CreateInvoiceView.swift
//  CreditCard
//
//  Created by IvanDev on 7.12.23.
//

import SwiftUI

struct CreateInvoiceView: View {
    
    @Environment(\.dismiss) var dismiss

    @State private var number = ""
    @State private var name = ""
    @State private var amount = ""
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var pOfp = ""
    @State private var pu = "Service1"
    @State private var point = "Office"
    @State private var sale = "0"
        
    @State var shouldShowPhotoPicker = false

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Main information")) {
                    TextField("Number", text: $number)
                    TextField("Amount", text: $amount)
                    Picker("Service", selection: $pu) {
                        Text("Service1").tag("Cards1")
                        Text("Service2").tag("Account2")
                        Text("Service3").tag("Cards")
                    }
                    Picker("Outlet", selection: $pu) {
                        Text("Office").tag("Cards2")
                        Text("Street 50").tag("Account")
                    }
                }
                
                Section(header: Text("Payment rules")) {
                    DatePicker("Start date",
                               selection: $startDate,
                               displayedComponents: .date)
                    DatePicker("End date",
                               selection: $endDate,
                               displayedComponents: .date)
                }
                
                Section(header: Text("Other info")) {
                    TextField("Name payed", text: $name)
                    TextField("Purpose of payment", text: $pOfp)
                    Picker("Sale %", selection: $sale) {
                        Text("0").tag("percent")
                        Text("10").tag("percent1")
                        Text("20").tag("percent2")
                        Text("50").tag("percent3")
                        Text("90").tag("percent4")
                        Text("100").tag("percent5")
                    }
                }
                
                Button {
                    
                } label: {
                    Text("Create invoice")
                        .foregroundColor(.white.opacity(0.87))
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                        .background(
                            LinearGradient(
                                stops: [
                                    Gradient.Stop(color: Color(red: 0.85, green: 0.65, blue: 0.76), location: 0.00),
                                    Gradient.Stop(color: Color(red: 0.95, green: 0.22, blue: 0.48), location: 1.00),
                                ],
                                startPoint: UnitPoint(x: 0.3, y: 0),
                                endPoint: UnitPoint(x: 0.87, y: 1.91)
                            )
                            .cornerRadius(15)
                        )
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
            }
            .navigationTitle("Create invoice")
            .navigationBarItems(leading: CancelButton)
        }
    }
    
    @ViewBuilder
    var CancelButton: some View {
        Button {
            dismiss()
        } label: {
            Text("Back")
        }
    }
}

struct CreateInvoiceView_Previews: PreviewProvider {
    static var previews: some View {
        CreateInvoiceView()
    }
}
