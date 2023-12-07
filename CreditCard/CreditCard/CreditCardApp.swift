//
//  CreditCardApp.swift
//  CreditCard
//
//  Created by Эван Крошкин on 17.08.22.
//

import SwiftUI

@main
struct CreditCardApp: App {
    let coreDataController = CoreDataManager.shared

    var body: some Scene {
        WindowGroup {
            InvoiceMainView()
//            MainView()
//                .environment(\.managedObjectContext, coreDataController.container.viewContext)
        }
    }
}
