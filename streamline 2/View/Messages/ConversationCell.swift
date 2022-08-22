//
//  ConversationCell.swift
//  streamline
//
//  Created by Matt Forgacs on 5/24/21.
//

import SwiftUI
import Kingfisher

struct ConversationCell: View {
    let message: Message
    
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 12) {
                KFImage(URL(string: message.user.profileImageUrl))
                    .resizable()
                    .scaledToFill()
                    .clipped()
                    .frame(width: 56, height: 56)
                    .cornerRadius(28)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(message.user.fullname)
                            .font(.system(size: 14, weight: .semibold))
                    
                    Text(message.text)
                            .font(.system(size: 15))
                        .lineLimit(/*@START_MENU_TOKEN@*/2/*@END_MENU_TOKEN@*/)
                    
                }
                .foregroundColor(Color("AdaptiveColor"))
                .frame(height: 64)
                .padding(.trailing)
            }
            Divider()
        }
    }
}
