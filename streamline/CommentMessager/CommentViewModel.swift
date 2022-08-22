//
//  CommentViewModel.swift
//  streamline
//
//  Created by Matt Forgacs on 12/14/21.
//

import SwiftUI
import Firebase

class CommentViewModel: ObservableObject {
//    @Published var user: User
    @Published var userId: String
    @Published var postId: String
    @Published var comments = [Comment]()
    
    init(userId: String, postId: String) {
        self.userId = userId
        self.postId = postId
        fetchComments()
    }
   
    func fetchComments() {
        guard let uid = AuthViewModel.shared.userSession?.uid else { return }
        
        let query = COLLECTION_COMMENTS.document(uid).collection(userId).whereField("postId", isEqualTo: postId)
        query.order(by: "timestamp", descending: true)
        
        query.addSnapshotListener { snapshot, error in
            guard let changes = snapshot?.documentChanges.filter({ $0.type == .added }) else { return }
            
            changes.forEach { change in
                let commentData = change.document.data()
                guard let fromId = commentData["fromId"] as? String else { return }
                
                COLLECTION_USERS.document(fromId).getDocument { snapshot, _ in
                    guard let data = snapshot?.data() else { return }
                    let user = User(dictionary: data)
                    self.comments.append(Comment(user: user, dictionary: commentData))
                    self.comments.sort(by: { $0.timestamp.dateValue() < $1.timestamp.dateValue() })

                }
            }
        }
    }


    func sendComment(_ commentText: String) {
        guard let currentUid = AuthViewModel.shared.userSession?.uid else { return }
        let currentUserRef = COLLECTION_COMMENTS.document(currentUid).collection(userId).document()
        let receivingUserRef = COLLECTION_COMMENTS.document(userId).collection(currentUid)
        let receivingRecentRef = COLLECTION_COMMENTS.document(userId).collection("recent-comments")
        let currentRecentRef = COLLECTION_COMMENTS.document(currentUid).collection("recent-comments")
        let commentID = currentUserRef.documentID
        
        let data: [String: Any] = ["commentText": commentText,
                                   "postId": postId,
                                   "id": commentID,
                                   "fromId": currentUid, "toId": userId,
                                   "timestamp": Timestamp(date: Date())]
        
        currentUserRef.setData(data)
        receivingUserRef.document(commentID).setData(data)
        receivingRecentRef.document(userId).setData(data)
        currentRecentRef.document(userId).setData(data)

    }
}
