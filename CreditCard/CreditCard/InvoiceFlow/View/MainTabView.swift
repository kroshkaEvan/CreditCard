//
//  MainTabView.swift
//  CreditCard
//
//  Created by IvanDev on 7.12.23.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            InvoiceMainView()
                .badge(2)
                .tabItem {
                    Label("Invoice", systemImage: "tray.and.arrow.down.fill")
                }
            AnalitycsView()
                .tabItem {
                    Label("Analitycs", systemImage: "tray.and.arrow.up.fill")
                }
            ProfileView()
                .badge("!")
                .tabItem {
                    Label("Account", systemImage: "person.crop.circle.fill")
                }
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
