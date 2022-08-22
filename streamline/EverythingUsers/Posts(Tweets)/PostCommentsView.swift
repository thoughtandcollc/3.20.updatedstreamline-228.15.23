//
//  PostCommentsView.swift
//  streamline
//
//  Created by Matt Forgacs on 12/23/21.
//

import SwiftUI

struct PostCommentsView: View {
    //    @State private var usedWord = [String]()
    @State private var commentText = ""
    //    @State private var use
    @ObservedObject var viewModel: PostCommentsViewModel
    
    
    var body: some View {
        VStack {
            HStack {
                TextField("Enter your text", text: $commentText)
                Button {
                    let answer = commentText.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
                    guard answer.count > 0 else { return }
                    
                    sendComment()
                } label: {
                    Text("Send")
                }
            }
            
            ScrollView(showsIndicators: false) {
                LazyVStack {
                    ForEach(viewModel.comments) { comment in
                        PostCommentCellView(comment: comment)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .onAppear {
                                if self.viewModel.comments.last?.id == comment.id {
                                    viewModel.fetchComments()
                                }
                            }
                    }
                }
            }
        }
        .padding(.horizontal, 20)
    }
    
    func sendComment() {
        viewModel.sendComment(commentText)
        commentText = ""
    }
}

struct ListAttempt_Previews: PreviewProvider {
    static var previews: some View {
        PostCommentsView(viewModel: .init(userId: "", postId: ""))
    }
}
