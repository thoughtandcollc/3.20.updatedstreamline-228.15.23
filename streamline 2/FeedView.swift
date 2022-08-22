//
//  FeedView.swift
//  streamline
//
//  Created by Matt Forgacs on 5/23/21.
//

import SwiftUI

//struct FeedView: View {
//    @State var  isShowingNewPostView = false
//    @ObservedObject var viewModel: FeedViewModel
//    @State var selectedFilter: NotesFilterOptions = .groupnotes

    struct FeedView: View {
        @State var isShowingNewPostView = false
        @ObservedObject var viewModel: FeedViewModel
        @ObservedObject var feedViewModel = FeedViewModel()

        var body: some View {
            ZStack(alignment: .bottomTrailing) {
                ScrollView {
                    LazyVStack {
                        ForEach(viewModel.posts) { post in
                            NavigationLink(destination: PostDetailView(post: post)) {
                                TweetCell(post: post)
                            }
                        }
                    } .padding()
                }
                
                Button(action: { isShowingNewPostView.toggle() }, label: {
                    Image("Tweet")
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 28, height: 28)
                        .padding()
                })
                .background(Color(.systemOrange))
                .foregroundColor(.white)
                .clipShape(Circle())
                .padding()
                .fullScreenCover(isPresented: $isShowingNewPostView) {
                    NewPost(isPresented: $isShowingNewPostView)
                }
            }
        }
    }

