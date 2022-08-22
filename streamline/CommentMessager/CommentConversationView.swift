//
//  CommentContainer.swift
//  streamline
//
//  Created by Matt Forgacs on 12/15/21.
//


import SwiftUI


struct CommentsConversationView: View {
    
    @State var isShowingNewCommentView = false
    @State var showChat = false
    @State var user: User?
    @ObservedObject var viewModel = CommentConversationsViewModel()
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            
            if let user = user {
                NavigationLink(destination: LazyView(CommentChatView(user: user)),
                               isActive: $showChat,
                               label: {})
            }
            
            ScrollView {
                VStack {
                    ForEach(viewModel.recentComments) { comment in
                        NavigationLink(
                            destination: LazyView(CommentChatView(user: comment.user)),
                            label: {
                                CommentCell(comment: comment)
                            })
                    }
                }.padding()
            }
            
            //        HStack {
            //            Spacer()
            //
            //        Button(action: { self.isShowingNewCommentView.toggle() }, label: {
            //            Image(systemName: "envelope")
            //                .resizable()
            //                .scaledToFit()
            //                .frame(width: 24, height: 24)
            //                .padding()
            //
            //        })
            //        .background(Color(.systemOrange))
            //        .foregroundColor(.white)
            //        .clipShape(Circle())
            //        .padding()
            //        .sheet(isPresented: $isShowingNewCommentView, content: {
            //            CommentCell(comment: comment)
            //            })
            //        }
        }
    }
}

