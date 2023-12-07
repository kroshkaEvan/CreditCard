//
//  InvoiceModel.swift
//  CreditCard
//
//  Created by IvanDev on 29.11.23.
//

import SwiftUI

struct Invoice: Identifiable {
    var id: UUID = .init()
    var number: String
    var state: InvoiceState?
    var totalAmount: String
    var transaction: [Transaction]?
    
    var color: Color = Color.getRandomColor()

}

enum InvoiceState: String {
    case created
    case active
    case deleted
}

struct Transaction: Identifiable {
    var id: UUID = .init()
    var namePayer: String
    var paidAmount: String
    var color: Color = Color.getRandomColor()
}

struct OverviewModel: Identifiable {
    var id: UUID = .init()
    var type: OverviewType
    var value: [OverviewValue]
}

struct OverviewValue: Identifiable {
    var id: UUID = .init()
    var month: Date
    var amount: Double
}

enum OverviewType: String {
    case income = "Income"
    case expense = "Expense"
}

class MockData {
    static let shared = MockData()
    
    var invoices: [Invoice] = [
        .init(number: "1-1-10", state: .created, totalAmount: "30 BYN", transaction: [.init(namePayer: "Miow", paidAmount: "30 BYN")]),
        .init(number: "1-1-20", state: .deleted, totalAmount: "440 BYN", transaction: [.init(namePayer: "Sergio", paidAmount: "440 BYN"),
                                                                                        .init(namePayer: "Kira", paidAmount: "180 BYN")]),
        .init(number: "1-1-30", state: .active, totalAmount: "400 BYN", transaction: [.init(namePayer: "Hann", paidAmount: "400 BYN"),
                                                                                      .init(namePayer: "Obi Van", paidAmount: "400 BYN"),
                                                                                      .init(namePayer: "Palpatin", paidAmount: "400 BYN"),
                                                                                      .init(namePayer: "Enakin", paidAmount: "400 BYN")]),
        .init(number: "1-1-40", state: .active, totalAmount: "0 BYN", transaction: [.init(namePayer: "Вася", paidAmount: "50 BYN"),
                                                                                    .init(namePayer: "Гретта", paidAmount: "380 BYN"),
                                                                                    .init(namePayer: "Nico", paidAmount: "200 BYN"),
                                                                                    .init(namePayer: "Leo Pepsi", paidAmount: "4460 BYN"),
                                                                                    .init(namePayer: "Lewa", paidAmount: "1380 BYN"),
                                                                                    .init(namePayer: "left cheburek", paidAmount: "380 BYN")]),
    ]
    
    let allTransaction: [Transaction] = [.init(namePayer: "Inna", paidAmount: "50 BYN"),
                                         .init(namePayer: "Gretta", paidAmount: "380 BYN"),
                                         .init(namePayer: "Nico", paidAmount: "200 BYN"),
                                         .init(namePayer: "Leo", paidAmount: "4460 BYN"),
                                         .init(namePayer: "Lewa", paidAmount: "130 BYN"),
                                         .init(namePayer: "Hann", paidAmount: "400 BYN"),
                                         .init(namePayer: "Obi Van", paidAmount: "400 BYN"),
                                         .init(namePayer: "Palpatin", paidAmount: "400 BYN"),
                                         .init(namePayer: "Enakin", paidAmount: "400 BYN"),
                                         .init(namePayer: "Sergio", paidAmount: "440 BYN"),
                                         .init(namePayer: "Kira", paidAmount: "180 BYN"),
                                         .init(namePayer: "Miow", paidAmount: "30 BYN")]
    
    var overviewData: [OverviewModel] = [
        .init(type: .income, value: [
            .init(month: .addMonth(-6), amount: 2345),
            .init(month: .addMonth(-5), amount: 145),
            .init(month: .addMonth(-4), amount: 456),
            .init(month: .addMonth(-3), amount: 678),
            .init(month: .addMonth(-2), amount: 2345),
            .init(month: .addMonth(-1), amount: 2345)
        ]),
        .init(type: .expense, value: [
            .init(month: .addMonth(-6), amount: 321),
            .init(month: .addMonth(-5), amount: 1425),
            .init(month: .addMonth(-4), amount: 4526),
            .init(month: .addMonth(-3), amount: 6728),
            .init(month: .addMonth(-2), amount: 235),
            .init(month: .addMonth(-1), amount: 345)
        ])
    ]
}

