//
//  CommentView.swift
//  streamline
//
//  Created by Matt Forgacs on 12/14/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct CommentCell: View {
    let comment: Comment
    
    var body: some View {
        HStack {
            if comment.isFromCurrentUser {
                Spacer()
                Text(comment.commentText)
                    .padding()
                    .background(Color.orange)
                    .clipShape(ChatBubble(isFromCurrentUser: true))
                    .foregroundColor(.white)
                    .padding(.horizontal)
                    .padding(.leading, 100)
                    .padding(.trailing, 16)
            } else {
                HStack(alignment: .bottom) {
                    AnimatedImage(url: URL(string: comment.user.profileImageUrl))
                        .indicator(SDWebImageActivityIndicator.grayLarge)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                    
                    Text(comment.commentText)
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
