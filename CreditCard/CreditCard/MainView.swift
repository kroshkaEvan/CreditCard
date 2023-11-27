//
//  ContentView.swift
//  CreditCard
//
//  Created by Эван Крошкин on 17.08.22.
//

import SwiftUI

struct MainView: View {
    
    @State var shouldPresentCardForm = false
    @State var shouldShowTransactionForm = false
    @State private var selectedSegment = "Cards"
    
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Card.timestamp,
                                           ascending: false)],
        animation: .default)
    
    private var cards: FetchedResults<Card>
                
    var body: some View {
        ZStack(alignment: .top) {
            ScrollView {
                VStack {
                    Picker("Options", selection: $selectedSegment) {
                        Text("Cards").tag("Cards")
                        Text("Account").tag("Account")
                    }
                    .pickerStyle(.segmented)
                    .padding([.top], 30)
                    
                    if !cards.isEmpty {
                        TabView {
                            let cardsArray: [Card] = Array(cards)
                            WalletView().environmentObject(Wallet(cards: cardsArray))
                                .padding([.top], 50)
                        }
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                        .frame(minHeight: 350)
                        .indexViewStyle(.page(backgroundDisplayMode: .interactive))
                        .padding(.vertical, 10)
                    } else {
                        emptyMessage
                    }
                    
                    HStack(alignment: .center) {
                        MenuButton(action: { },
                                   imageName: "Send2",
                                   scaleEffect: 1)
                        Spacer()
                        MenuButton(action: { },
                                   imageName: "Wallet",
                                   scaleEffect: 1)
                        Spacer()
                        MenuButton(action: { },
                                   imageName: "Send",
                                   scaleEffect: 2)
                        Spacer()
                        MenuButton(action: {},
                                   imageName: "Stats",
                                   scaleEffect: 1)
                    }
                    .frame(alignment: .center)
                    .padding([.leading, .trailing], 20)
                    
                    AddCreditCard()
                        .frame(alignment: .center)
                        .cornerRadius(30)
                        .padding([.all], 20)
                }
            }
        }
        .background(Color(red: 0.1, green: 0.09, blue: 0.24))
    }
    
    var emptyMessage: some View {
        VStack {
            Text("You currently have no cards in the system")
                .padding(.horizontal, 50)
                .padding(.vertical)
                .multilineTextAlignment(.center)
        }
        .font(.system(size: 24,
                      weight: .semibold,
                      design: .monospaced))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let viewContext = CoreDataManager.shared.container.viewContext
        MainView()
            .environment(\.managedObjectContext, viewContext)
    }
}

struct MenuButton: View {
    var action: () -> Void

    var imageName: String
    
    var scaleEffect: Double
    
    var body: some View {
        Button {
            self.action()
        } label: {
            Image(imageName)
                .resizable()
                .scaleEffect(scaleEffect)
                .frame(width: 45,
                       height: 45,
                       alignment: .center)
                .padding()
                .background(
                    LinearGradient(
                        stops: [
                            Gradient.Stop(color: Color(red: 0.12, green: 0.11, blue: 0.29), location: 0.00),
                            Gradient.Stop(color: Color(red: 0.12, green: 0.11, blue: 0.29), location: 0.00),
                            Gradient.Stop(color: Color(red: 0.2, green: 0.19, blue: 0.46), location: 1.00),
                        ],
                        startPoint: UnitPoint(x: 0.78, y: 0.55),
                        endPoint: UnitPoint(x: 0.17, y: 0.05)
                    )
                )
                .cornerRadius(20)
        }
    }
}
