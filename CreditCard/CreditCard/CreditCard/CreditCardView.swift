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
        GeometryReader { (geometry) in
            VStack(alignment: .center, spacing: 0) {
                Group {
                    Spacer()
                    self.editButton
                    HStack(alignment: .center) {
                        self.chip(for: geometry)
                        Spacer()
                        self.contactLess(for: geometry)
                    }.padding(.horizontal)
                    VStack(spacing: 5) {
                        self.cardNumber
                        self.expiration
                    }.padding(.bottom, geometry.size.height / 100)
                    ZStack(alignment: .center) {
                        self.cardHolderName
                        HStack {
                            Spacer()
                            self.cardLogo(for: geometry)
                        }
                    }.padding(.horizontal)
                    Spacer()
                }.shadow(color: .gray, radius: 5, x: 0, y: 0)
            }.frame(width: geometry.size.width,
                    height: geometry.size.width / CGFloat(1.7))
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
            .cornerRadius(10)
            .shadow(radius: 10)
        }
    }
}
    
extension CreditCardView {
    
    var editButton: some View {
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
        .frame(height: 44, alignment: .topTrailing)
    }
    
    var expiration: some View {
        VStack(alignment: .center, spacing: 3) {
            Group {
                Text("MONTH/YEAR").font(.system(size: 12))
                Text("\(card.date?.convertDateToExpirationDateString() ?? "")")
                    .font(.system(size: 15))
            }
            .foregroundColor(.white)
        }
    }
    
    func cardLogo(for geometry: GeometryProxy) -> some View {
        Image(card.number?.determineCardType() ?? "MasterCard")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(height: geometry.size.height / 18)
            .fixedSize()
    }
    
    var cardHolderName: some View {
        Text(card.name ?? "Your name")
            .minimumScaleFactor(2)
            .font(.system(size: 16))
            .shadow(radius: 3)
            .padding(.horizontal)
            .foregroundColor(.white)
    }
    
    var cardNumber: some View {
        Text(card.number?.addingSpacesEveryFourCharacters() ?? "**** **** **** ****")
            .font(.system(size: 23, weight: .medium))
            .foregroundColor(.white)
    }
    
    func chip(for geometry: GeometryProxy) -> some View {
        Image("Chip")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(height: geometry.size.height / 12)
            .fixedSize()
    }
    
    func contactLess(for geometry: GeometryProxy) -> some View {
        Image("Wifi") //radiowaves.right")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: geometry.size.height / 15)
            .fixedSize()
    }
    
}
