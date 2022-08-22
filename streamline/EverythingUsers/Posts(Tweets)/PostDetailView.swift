//
//  PostDetailView.swift
//  streamline
//
//  Created by Matt Forgacs on 5/29/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct PostDetailView: View {
    let post: Post
    //    @State var commentText: String = ""
    @State private var height: CGFloat = .zero
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                AnimatedImage(url: URL(string: post.profileImageUrl))
                    .indicator(SDWebImageActivityIndicator.grayLarge)
                    .resizable()
                    .scaledToFill()
                    .clipped()
                    .frame(width: 56, height: 56)
                    .cornerRadius(28)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(post.fullname)
                        .font(.system(size: 14, weight: .semibold))
                    
                    Text("@OnTheMargin")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
                Spacer()
                HStack(alignment: .top, spacing: /*@START_MENU_TOKEN@*/nil/*@END_MENU_TOKEN@*/, content: {
                    ReplyCell()
                    
                })
                .padding()
            }
            //            .padding(.leading)
            
            TextWithLinks(string: post.caption, fontSize: 22, dynamicHeight: $height) { url in
                openBrowserWith(url: url.absoluteString)
            }
            .frame(minHeight: height)
            .fixedSize(horizontal: false, vertical: true)
            .padding()
            
            if post.media.count > 0 {
                let columns = Array(repeating: GridItem(.flexible()), count: 2)
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(Array(post.media.enumerated()), id: \.element.id) { index, media in
//                        let media = post.media[index]
                        MorePhotoView(media: media) {
                            
                        } deleteAction: {
                            print(index)
                        }
                    }
                }
                .padding(.horizontal)
                Spacer(minLength: 20)
            }
            
            Text(post.detailedTimestampString)
                .font(.system(size: 14))
                .foregroundColor(.gray)
                .padding(.leading)
            
            Divider()
            HStack(spacing: 12) {
                PostActionView(post: post)
            }
            Divider()
            Spacer()
            VStack {
                PostCommentsView(viewModel: .init(userId: post.uid, postId: post.id))
            }
            
            
        } .padding()
        Spacer()
    }
}
