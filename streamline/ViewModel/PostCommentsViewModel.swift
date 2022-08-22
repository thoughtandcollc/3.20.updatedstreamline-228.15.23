//
//  PostCommentsViewModel.swift
//  streamline
//
//  Created by Tayyab Ali on 10/01/2022.
//

import Foundation
import FirebaseFirestore

class PostCommentsViewModel: ObservableObject {
    @Published var userId: String
    @Published var postId: String
    @Published var comments = [Comment]()
    
    private var fetchingMore = true
    private var lastDocumentSnapshot: DocumentSnapshot!

    init(userId: String, postId: String) {
        self.userId = userId
        self.postId = postId
        fetchComments()
    }
   
    func fetchComments() {
        
        if !fetchingMore {
            return
        }
        fetchingMore = true
        
        var query: Query!
        
        if comments.isEmpty {
            print("fetching from start")
            query = COLLECTION_POSTS.document(postId).collection(COMMENTS).order(by: "timestamp", descending: true).limit(to: 20)
        } else {
            print("fetching from bottom")
            query = COLLECTION_POSTS.document(postId).collection(COMMENTS).order(by: "timestamp", descending: true).start(afterDocument: lastDocumentSnapshot)
        }
        
        query.getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else {
                return
            }
            self.lastDocumentSnapshot = documents.last
            self.fetchingMore = documents.isEmpty == false
            
            documents.forEach { document in
                let commentData = document.data()
                guard let fromId = commentData["fromId"] as? String else { return }
                COLLECTION_USERS.document(fromId).getDocument { snapshot, _ in
                    guard let data = snapshot?.data() else { return }
                    let user = User(dictionary: data)
                    self.comments.append(Comment(user: user, dictionary: commentData))
                    //                    self.comments.sort(by: { $0.timestamp.dateValue() < $1.timestamp.dateValue() })
                }
            }
        }
    }
    
//    func fetchFromBottom() {
//
//        if !fetchingMore {
//            return
//        }
//        print("fetching from bottom")
//
//        fetchingMore = true
//
//        let query = COLLECTION_POSTS.document(postId).collection(COMMENTS).order(by: "timestamp", descending: false).start(afterDocument: lastDocumentSnapshot)
//
//        query.getDocuments { snapshot, error in
//            guard let documents = snapshot?.documents else {
//                return
//            }
//
//            self.fetchingMore = !documents.isEmpty
//
//            self.lastDocumentSnapshot = documents.last
//            documents.forEach { document in
//                let commentData = document.data()
//                guard let fromId = commentData["fromId"] as? String else { return }
//
//                COLLECTION_USERS.document(fromId).getDocument { snapshot, _ in
//                    guard let data = snapshot?.data() else { return }
//                    let user = User(dictionary: data)
//                    self.comments.append(Comment(user: user, dictionary: commentData))
//                    self.comments.sort(by: { $0.timestamp.dateValue() > $1.timestamp.dateValue() })
//                }
//            }
//        }
//    }

    func sendComment(_ commentText: String) {
        guard let currentUid = AuthViewModel.shared.userSession?.uid else { return }

        let query = COLLECTION_POSTS.document(postId).collection(COMMENTS).document()
        let commentID = query.documentID

        let data: [String: Any] = ["commentText": commentText,
                                   "id": commentID,
                                   "fromId": currentUid,
                                   "timestamp": Timestamp(date: Date())]
        query.setData(data)
        
        let comment = Comment(user: AuthViewModel.shared.user!, dictionary: data)
        self.comments.insert(comment, at: 0)
        
        self.sendNotification(toUid: userId)
    }
    
    func sendNotification(toUid uid: String) {
        guard let currentUser = AuthViewModel.shared.user else { return }
        
        let query = COLLECTION_USERS.document(uid).collection("notifications").document()
        
        let notification = AppNotification(id: query.documentID,
                                           senderId: currentUser.id,
                                           username: currentUser.fullname,
                                           receiverId: uid,
                                           profileImageUrl: currentUser.profileImageUrl,
                                           type: .comment,
                                           postId: postId,
                                           title: "Comment!",
                                           body: "\(currentUser.fullname) comment on your post.",
                                           timestamp: Timestamp(date: Date()))
                
        do {
            let _ = try query.setData(from: notification) { error in
                if let error = error {
                    debugPrint(error.localizedDescription)
                    return
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
