//
//  CommentCell.swift
//  streamline
//
//  Created by Matt Forgacs on 12/14/21.
//

import SwiftUI
import Firebase

struct CommentChatView: View {
    let user: User
    @ObservedObject var viewModel: CommentViewModel
    @State var commentText: String = ""
    
    init(user: User) {
        self.user = user
        self.viewModel = CommentViewModel(userId: user.id, postId: "")
    }
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(viewModel.comments) { comment in
                        CommentCell(comment: comment)
                    }
                }
            } .padding(.top)
            
            CommentInputView(commentText: $commentText, action: sendComment)
                .padding()
            
        } .navigationTitle(user.fullname)
    }
    
    func sendComment() {
        viewModel.sendComment(commentText)
        commentText = ""
    }
}
