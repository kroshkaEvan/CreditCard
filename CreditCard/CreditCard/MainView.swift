//
//  ContentView.swift
//  CreditCard
//
//  Created by Эван Крошкин on 17.08.22.
//

import SwiftUI

struct MainView: View {
    
    @State var shouldPresentCardForm = false
    
    var body: some View {
        NavigationView{
            ScrollView{
                TabView{
                    ForEach(0..<5) { num in
                        CreditCardView()
                            .padding(.bottom, 50)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                .frame(height: 300)
                .indexViewStyle(.page(backgroundDisplayMode: .interactive))
                
                Spacer().fullScreenCover(isPresented: $shouldPresentCardForm,
                                         onDismiss: nil) {
                    AddCreditCard()
                }
            }
            .navigationTitle("Credit Cards")
            .navigationBarItems(leading: addItemButton,
                                trailing: addCardButton)
        }
    }
    
    var addItemButton: some View {
        Button(action: {
            withAnimation {
                let viewContext = CoreDataController.shared.container.viewContext
                let card = Card(context: viewContext)
                card.timestamp = Date()

                do {
                    try viewContext.save()
                } catch {
                    
                }
            }
        }, label: {
            Text("Add Item")
                .font(.system(size: 16,
                              weight: .semibold))
                .padding(EdgeInsets(top: 8,
                                    leading: 8,
                                    bottom: 8,
                                    trailing: 8))
                .foregroundColor(.blue)
                .cornerRadius(7)
        })
    }
    
    var addCardButton: some View {
        Button(action: {
            shouldPresentCardForm.toggle()
        }, label: {
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
        })
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
