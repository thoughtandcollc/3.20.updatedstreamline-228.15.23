//
//  MessageView.swift
//  streamline
//
//  Created by Matt Forgacs on 5/25/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct MessageView: View {
    let message: Message
    
    var body: some View {
        HStack {
            if message.isFromCurrentUser {
                Spacer()
                Text(message.text)
                    .padding()
                    .background(Color.orange)
                    .clipShape(ChatBubble(isFromCurrentUser: true))
                    .foregroundColor(.white)
                    .padding(.horizontal)
                    .padding(.leading, 100)
                    .padding(.trailing, 16)
            } else {
                HStack(alignment: .bottom) {
                    AnimatedImage(url: URL(string: message.user.profileImageUrl ))
                        .indicator(SDWebImageActivityIndicator.grayLarge)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                    
                    Text(message.text)
                        .padding()
                        .background(Color(.systemGray5))
                        .clipShape(ChatBubble(isFromCurrentUser: false))
                        .foregroundColor(Color("AdaptiveColor"))
                    
                } .padding(.horizontal)
                .padding(.trailing, 100)
                .padding(.leading, 16)
                Spacer()
                
            }
        }
    }
}
