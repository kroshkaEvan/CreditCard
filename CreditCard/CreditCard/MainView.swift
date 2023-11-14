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
    
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Card.timestamp,
                                           ascending: false)],
        animation: .default)
    
    private var cards: FetchedResults<Card>
                
    var body: some View {
        NavigationView{
            VStack{
                Spacer().fullScreenCover(isPresented: $shouldPresentCardForm,
                                         onDismiss: nil) {
                    AddCreditCard()
                }
                Spacer()
                if !cards.isEmpty {
                        let cardsArray: [Card] = Array(cards)
                        WalletView().environmentObject(Wallet(cards: cardsArray))
                    .frame(height: 600)
                    .navigationBarItems(trailing:
                                    addCardButton
                    )


                } else {
                    emptyMessage
                }
            }
            .navigationTitle("Credit Cards")
            .navigationBarItems(leading:
                                    HStack{
                addItemButton
                deleteItemButton
            })
        }
    }
    
    var emptyMessage: some View {
        VStack {
            Text("You currently have no cards in the system")
                .padding(.horizontal, 50)
                .padding(.vertical)
                .multilineTextAlignment(.center)
            Button {
                shouldPresentCardForm.toggle()
            } label: {
                Text("+ Add first card")
                    .foregroundColor(.white)
                    .font(.system(size: 25,
                                  weight: .bold,
                                  design: .default))
            }
            .padding(EdgeInsets(top: 15,
                                leading: 15,
                                bottom: 15,
                                trailing: 15))
            .background(.blue)
            .cornerRadius(10)
        }
        .font(.system(size: 24,
                      weight: .semibold,
                      design: .monospaced))
    }
    
    var addItemButton: some View {
        Button {
            withAnimation {
                let viewContext = CoreDataManager.shared.container.viewContext
                let card = Card(context: viewContext)
                card.timestamp = Date()

                do {
                    try viewContext.save()
                } catch {
                    
                }
            }
        } label: {
            Text("Add Item")
                .font(.system(size: 16,
                              weight: .semibold))
                .padding(EdgeInsets(top: 8,
                                    leading: 8,
                                    bottom: 8,
                                    trailing: 8))
                .foregroundColor(.blue)
                .cornerRadius(7)
        }
    }
    
    var deleteItemButton: some View {
        Button {
            withAnimation {
                cards.forEach {card in
                    viewContext.delete(card)
                }
                do {
                    try viewContext.save()
                } catch {
                    
                }
            }
        } label: {
            Text("Delete Item")
                .font(.system(size: 16,
                              weight: .semibold))
                .padding(EdgeInsets(top: 8,
                                    leading: 8,
                                    bottom: 8,
                                    trailing: 8))
                .foregroundColor(.blue)
                .cornerRadius(7)
        }
    }
    
    var addCardButton: some View {
        Button {
            shouldPresentCardForm.toggle()
        } label: {
            Text("+ Card")
                .font(.system(size: 16,
                              weight: .semibold))
                .padding(EdgeInsets(top: 8,
                                    leading: 8,
                                    bottom: 8,
                                    trailing: 8))
                .background(Image("creditCard"))
                .foregroundColor(.white)
                .cornerRadius(7)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let viewContext = CoreDataManager.shared.container.viewContext
        MainView()
            .environment(\.managedObjectContext, viewContext)
    }
}
