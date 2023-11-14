//
//  CreditCardView.swift
//  CreditCard
//
//  Created by Эван Крошкин on 17.08.22.
//

import SwiftUI

struct CreditCardView: View {
    let card: Card
    
    @State var shouldShowActionSheet = false
    @State var shouldShowEditForm = false
    @State var refreshID = UUID()
    
    private func didTapDelete() {
        let viewContext = CoreDataManager.shared.container.viewContext
        viewContext.delete(card)
        do {
            try viewContext.save()
        } catch {
            
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack{
                Text(card.name ?? "Your name")
                    .font(.system(size: 25,
                                  weight: .bold,
                                  design: .monospaced))
                Spacer()
                Button {
                    shouldShowActionSheet.toggle()
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 30,
                                      weight: .bold,
                                      design: .monospaced))
                }
                .actionSheet(isPresented: $shouldShowActionSheet) {
                    .init(title: Text(self.card.name ?? ""),
                          message: Text("Options"),
                          buttons: [
                            .default(Text("Edit"),
                                     action: {
                                         shouldShowEditForm.toggle()
                                     }),
                            .destructive(Text("Delete card"),
                                         action:
                                            didTapDelete),
                            .cancel()
                          ])
                }
            }

            HStack {
                Image(card.typeSystem ?? "MasterCard")
                    .resizable()
                    .clipped()
                    .scaledToFit()
                    .frame(height: 70)
                Spacer()
                Text("Balance: 6,000 $")
                    .font(.system(size: 18, weight: .semibold))
            }
            
            Text(card.number ?? "**** **** **** ****")
                .font(.system(size: 30, weight: .semibold))
            
            Text("Credit limit: \(card.limit) $")
            
            HStack{ Spacer() }
        }.padding()
            .background(
                VStack{
                    if let firstColorData = card.firstColor,
                       let firstUIColor = UIColor.color(data: firstColorData),
                       let secondColorData = card.secondColor,
                       let secondUIColor = UIColor.color(data: secondColorData) {
                        let firstColor = Color(firstUIColor)
                        let secondColor = Color(secondUIColor)
                        LinearGradient(gradient:
                                        Gradient(colors: [firstColor,
                                                          secondColor]),
                                       startPoint: .topTrailing,
                                       endPoint: .bottomLeading)
                    } else {
                        LinearGradient(gradient:
                                        Gradient(colors: [Color.pink,
                                                          Color.blue]),
                                       startPoint: .topTrailing,
                                       endPoint: .bottomLeading)
                    }
                }
            )
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.yellow,
                                                               lineWidth: 2))
            .foregroundColor(.white)
            .cornerRadius(10)
            .shadow(color: .gray,
                    radius: 8)
            .padding(.horizontal)
            .padding(.top, 8)
            .fullScreenCover(isPresented: $shouldShowEditForm) {
                Text("Edit form")
                AddCreditCard(card: self.card)
            }
    }
}

//struct CreditCardView_Previews: PreviewProvider {
//    static var previews: some View {
//        CreditCardView(card: card)
//    }
//}
