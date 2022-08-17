//
//  CreditCardView.swift
//  CreditCard
//
//  Created by Эван Крошкин on 17.08.22.
//

import SwiftUI

struct CreditCardView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Visa Card")
                .font(.system(size: 25,
                              weight: .bold))
            HStack {
                Image("Visa")
                    .resizable()
                    .clipped()
                    .scaledToFit()
                    .frame(height: 70)
                Spacer()
                Text("Balance: 6,000 $")
                    .font(.system(size: 18, weight: .semibold))
            }
            
            Text("3456 2389 0943 1278")
            
            Text("Credit limit: 50,000 $")
            
            HStack{ Spacer() }
        }.padding()
            .background(
                LinearGradient(gradient:
                                Gradient(colors: [Color.pink,
                                                  Color.blue]),
                               startPoint: .topTrailing,
                               endPoint: .bottomLeading)
            )
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.yellow,
                                                               lineWidth: 2))
            .foregroundColor(.white)
            .cornerRadius(10)
            .shadow(color: .gray,
                    radius: 8)
            .padding(.horizontal)
            .padding(.top, 8)
    }
}
