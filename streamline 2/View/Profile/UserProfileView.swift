//
//  UserProfileView.swift
//  streamline
//
//  Created by Matt Forgacs on 5/25/21.
//

import SwiftUI

struct UserProfileView: View {
    let user: User
    @ObservedObject var viewModel: ProfileViewModel
    @State var selectedFilter: PostFilterOptions = .posts
    
    init(user: User) {
        self.user = user
        self.viewModel = ProfileViewModel(user: user)
    }
    
    var body: some View {
        ScrollView {
            VStack {
                ProfileHeaderView(viewModel: viewModel)
                    .padding()
                
                FilterButtonView(selectedOption: $selectedFilter)
                    .padding()
                
                ForEach(viewModel.posts(ForFilter: selectedFilter)) { post in
                    TweetCell(post: post)
                        .padding()
    
                }
            }
            .navigationTitle(user.fullname)
        }
    }
}


//Button(action: { isShowingNewPostView.toggle() }, label: {
//        Image("Tweet")
//            .resizable()
//            .renderingMode(/*@START_MENU_TOKEN@*/.template/*@END_MENU_TOKEN@*/)
//            .frame(width: 32, height: 32)
//            .padding()
//
//    })
//    .background(Color(.systemOrange))
//    .foregroundColor(.white)
//    .clipShape(Circle())
//    .padding()
//    .fullScreenCover(isPresented: $isShowingNewPostView) {
//        NewPost(isPresented: $isShowingNewPostView)
