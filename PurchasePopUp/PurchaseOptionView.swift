//
//  PurchaseOptionView.swift
//  streamline
//
//  Created by Matt on 10/4/22.
//

import SwiftUI

struct PurchaseOptionView: View {
    var sub: Subscription
    var isSelected: Bool
    
    
    var body: some View {
        VStack(spacing: 10) {
            Text("\(sub.month)")
                .font(.system(size: 44, weight: .light))
            
            Spacer().frame(height: 2)
            
            Text("month\(sub.month > 1 ? "s" : "")")
                .if(isSelected) {
                    $0.font(.system(size: 14, weight: .bold))
                }
            
            Spacer().frame(height: 2)
            
            Text("$\(String(format: "%.2f", sub.monthlyCost))/mo")
                .foregroundColor(.orange)

            Spacer().frame(height: 10)
            
            if sub.savePercent != nil {
                Text("SAVE \(sub.savePercent ?? 0)%")
                    .foregroundColor(.orange)
                    .font(.system(size: 16, weight: .heavy))
                    .frame(height: 22)
            } else {
                Spacer().frame(height: 22)
            }
            Spacer().frame(height: 12)
            
            Text("$\(String(format: "%.2f", sub.totalCost))")
                .font(.system(size: 20, weight: .bold))

        }
        .padding(.horizontal, 12)
        .padding(.vertical, 18)
        
        .if(!isSelected) {
            $0.foregroundColor(Color.black)
        }
            .if(isSelected && sub.tagLine == .none) {
                $0.overlay(RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(Color.orange, lineWidth: 1.5))
            }
            .if(isSelected && sub.tagLine != .none) {
                $0.overlay(
                    ZStack(alignment: .top) {
                        Rectangle()
                            .foregroundColor(.orange)
                            .frame(height: 20)
                            .cornerRadius(10)
                        
                        Text(sub.tagLine.rawValue)
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                            .lineLimit(1)
                            .padding(.top, 2)
                            .padding(.horizontal, 6)
                            .minimumScaleFactor(0.1)
                        
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .stroke(Color.orange, lineWidth: 1.5)
                    })
            }
    }
}

struct PurchaseOptionView_Previews: PreviewProvider {
    static var previews: some View {
        PurchaseOptionView(sub: Subscription.example1, isSelected: true)
        PurchaseOptionView(sub: Subscription.example2, isSelected: true)
        PurchaseOptionView(sub: Subscription.example3, isSelected: true)

    }
}

