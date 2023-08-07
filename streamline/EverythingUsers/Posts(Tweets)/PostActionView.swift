//
//  PostActionView.swift
//  streamline
//
//  Created by Matt Forgacs on 5/29/21.
//

import SwiftUI

struct PostActionView: View {
    let post: Post
    @State var isPresented = false
    @ObservedObject var viewModel: PostActionViewModel
    
    init(post: Post) {
        self.post = post
        self.viewModel = PostActionViewModel(post: post)
    }
    
    var body: some View {
        
        HStack(alignment: .center) {
            
            Button(action: {
                
                viewModel.didLike ? viewModel.unlikePost() : viewModel.likePost() }, label: {
                    
                    Image(systemName: viewModel.didLike ? "heart.fill" : "heart")
                        .font(.system(size: 16))
                        .frame(width: 32, height: 32)
                        .foregroundColor(viewModel.didLike ? .orange : .gray)
                    
                    Text("\(post.likes)")
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    NavigationLink(
                        destination: PostDetailView(posts: [post]),
                        label: {
                            HStack {
                                Image(systemName: "bubble.left")
                                    .font(.system(size: 16))
                                    .frame(width: 32, height: 32)
                                
                                Text("\(post.commentsCount ?? 0)")
                                    .foregroundColor(.gray)
                                
                            }
                        })
                    .foregroundColor(.gray)
                    .padding(.horizontal)
                    
                })
            
        }
    }
}
