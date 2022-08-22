//
//  TweetCell.swift
//  streamline
//
//  Created by Matt Forgacs on 5/23/21.
//

import SwiftUI
import Kingfisher

struct TweetCell: View {
    let post: Post
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top, spacing: 12) {
                KFImage(URL(string: post.profileImageUrl))
                    .resizable()
                    .scaledToFill()
                    .clipped()
                    .frame(width: 56, height: 56)
                    .cornerRadius(56 / 2)
                    .padding(.leading)
                
                VStack(alignment: .leading) {
                    HStack {
                    Text(post.fullname)
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(Color("AdaptiveColor"))
                //    Text("@NLChurch •")
                  //      .foregroundColor(.gray)
                        
                    Text(post.timestampString)
                        .foregroundColor(.gray)
                    }
                    
                    Text(post.caption)
                        .foregroundColor(Color("AdaptiveColor"))
                    
                }
            }
            .padding(.bottom)
            .padding(.trailing)
            
            PostActionView(post: post)
                
            Divider()
        }
        .padding(.leading, -16)
    }
}
