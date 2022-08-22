//
//  CommentConversationViewModel.swift
//  streamline
//
//  Created by Matt Forgacs on 12/15/21.
//

import SwiftUI

class CommentConversationsViewModel: ObservableObject {
    @Published var recentComments = [Comment]()
    private var recentCommentsDictionary = [String: Comment]()
    
    init() {
        fetchRecentComments()
        
    }
    func fetchRecentComments() {
        guard let uid = AuthViewModel.shared.userSession?.uid else { return }
        
        let query = COLLECTION_COMMENTS.document(uid).collection("recent-comments")
        query.order(by: "timestamp", descending: true)
        
        query.addSnapshotListener { snapshot, error in
            guard let changes = snapshot?.documentChanges else { return }
            
            changes.forEach { change in
                let commentData = change.document.data()
                let uid = change.document.documentID
                
                COLLECTION_USERS.document(uid).getDocument { snapshot, _ in
                    guard let data = snapshot?.data() else { return }
                    let user = User(dictionary: data)
                    self.recentCommentsDictionary[uid] = Comment(user: user, dictionary: commentData)
                    
                    self.recentComments = Array(self.recentCommentsDictionary.values)
                }
            }
        }
    }
}
