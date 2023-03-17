//
//  PurchasePopup.swift
//  streamline
//
//  Created by Matt on 10/4/22.
//

import SwiftUI

struct PurchasePopup: View {
//    @Binding var isVisible: Bool
    
    @State private var selectedIndex: Int = 1
    
    let screen = UIScreen.main.bounds
    
    let subscriptions: [Subscription] = [
        Subscription.example1,
        Subscription.example2,
        Subscription.example3]
    
    func processPayment() {
      //  let product = subscriptions[selectedIndex]
    }
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                Spacer().frame(height: 40)
                VStack {
                    Text("Get OnTheMargin Premium")
                        .foregroundColor(.orange)
                        .font(.system(size: 24, weight: .bold))
                    
                    PurchaseSwipePromo()
                        .frame(height: geo.size.height / 3)
                        .padding(.top, -35)
                    
                    HStack {
                        ForEach(subscriptions.indices) { subIndex in
                            let sub = subscriptions[subIndex]
                            PurchaseOptionView(sub: sub, isSelected: subIndex == selectedIndex)
                                .onTapGesture(perform: {
                                  selectedIndex = subIndex
                                })
                        }
                    }
                    
                    Spacer()
                    
                    Button {
                        processPayment()
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 45)
                                .foregroundColor(.orange)
                            Text("Continue")
                                .foregroundColor(.white)
                                .font(.system(size: 20, weight: .heavy))
                        }
                    } .frame(height: 55)
                        .padding(.horizontal, 24)
                        .padding(.top, 12)
                    
                    Button {
                      //  isVisible = false
                    } label: {
                        Text("NO THANKS")
                            .foregroundColor(.orange)
                            .font(.system(size: 20, weight: .heavy))
                    }
                    .padding(.vertical, 18)
                    
                }
                .frame(width: geo.size.width)
                .padding(.vertical, 20)
                .background(RoundedRectangle(cornerRadius: 25, style: .continuous)
                    .foregroundColor(.white))
                
                Spacer()
                
                VStack(spacing: 4) {
                    Text("Recurring Billing, Cancel Anytime")
                        .foregroundColor(.white)
                        .font(.system(size: 14, weight: .semibold))
                    Text("Legal jargon")
                        .foregroundColor(Color.white.opacity(0.5))
                        .font(.system(size: 14, weight: .semibold))
                        .multilineTextAlignment(.center)
                    
                }
                .padding(.bottom, 20)
                .padding(.horizontal, 4)
                
                Spacer()
            }
            .background(Color.black.edgesIgnoringSafeArea(.all))
            
        }
        .frame(height: screen.height)
    }
}

//struct PurchasePopup_Previews: PreviewProvider {
//    static var previews: some View {
//        PurchasePopup(isVisible: .constant(true))
//    }
//}
