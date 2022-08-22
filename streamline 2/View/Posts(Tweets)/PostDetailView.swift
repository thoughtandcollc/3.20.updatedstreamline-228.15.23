//
//  PostDetailView.swift
//  streamline
//
//  Created by Matt Forgacs on 5/29/21.
//

import SwiftUI
import Kingfisher

struct PostDetailView: View {
    let post: Post
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                KFImage(URL(string: post.profileImageUrl))
                    .resizable()
                    .scaledToFill()
                    .clipped()
                    .frame(width: 56, height: 56)
                    .cornerRadius(28)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(post.fullname)
                        .font(.system(size: 14, weight: .semibold))
                    
                    Text("@NLChurch")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
            }
                Spacer()
                HStack(alignment: .top, spacing: /*@START_MENU_TOKEN@*/nil/*@END_MENU_TOKEN@*/, content: {
                    ReplyCell()
                    
                })
                .padding()
            }
            .padding(.leading)
        
            
            Text(post.caption)
                .font(.system(size: 22))
                .padding()
            
            Text(post.detailedTimestampString)
                .font(.system(size: 14))
                .foregroundColor(.gray)
                .padding(.leading)
            
            Divider()
                        
            HStack(spacing: 12) {
                PostActionView(post: post)
            }
            Divider()

            VStack {
            SadComments()
            }
        
        }
    }
}
