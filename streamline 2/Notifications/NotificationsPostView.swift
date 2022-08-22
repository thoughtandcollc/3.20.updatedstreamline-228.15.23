//
//  NotificationsPostView.swift
//  streamline
//
//  Created by Matt Forgacs on 9/20/21.
//

import SwiftUI
import Kingfisher

struct NotificationPostView: View {
    let post: Post
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                KFImage(URL(string: post.profileImageUrl))
                    .resizable()
                    .scaledToFill()
                    .clipped()
                    .frame(width: 24, height: 24)
                    .clipShape(Circle())
                
                Text(post.fullname)
                    .font(.system(size: 12, weight: .semibold))
                
//                Text("• @\(post.username)")
//                    .font(.system(size: 12))
//                    .foregroundColor(.gray)
            }
            
            Text(post.caption)
                .font(.system(size: 14))
        }
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 3)
                .stroke(Color(.systemGray4), lineWidth: 1)
        )
        .padding()
    }
}
