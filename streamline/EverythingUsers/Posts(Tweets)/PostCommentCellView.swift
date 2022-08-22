//
//  PostCommentCellView.swift
//  streamline
//
//  Created by Tayyab Ali on 10/01/2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct PostCommentCellView: View {
    let comment: Comment
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            AnimatedImage(url: URL(string: comment.user.profileImageUrl))
                .indicator(SDWebImageActivityIndicator.grayLarge)
                .resizable()
                .scaledToFill()
                .frame(width: 40, height: 40)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Text(comment.user.fullname)
                        .font(.system(size: 14, weight: .semibold))
                    Spacer()
                    Text(comment.timestampString)
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                }
                Text(comment.commentText)
                    .font(.system(size: 14))
            }
            .foregroundColor(Color("AdaptiveColor"))
        }
        .padding(.vertical, 7)

    }
}
