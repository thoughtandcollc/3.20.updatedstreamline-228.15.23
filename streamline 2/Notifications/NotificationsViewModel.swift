//
//  NotificationsViewModel.swift
//  streamline
//
//  Created by Matt Forgacs on 9/20/21.
//

import SwiftUI
import Firebase

class NotificationViewModel: ObservableObject {
    @Published var notifications = [Notification]()
    
    init() {
        fetchNotifications()
    }
    
    static func uploadNotification(toUid uid: String, type: NotificationType, post: Post? = nil) {
        guard let currentUser = AuthViewModel.shared.user else { return }
        guard uid != currentUser.id else { return }
        
        let docRef = COLLECTION_NOTIFICATIONS.document(uid).collection("notifications").document()
        
        var data: [String: Any] = ["timestamp": Timestamp(date: Date()),
                                   "uid": currentUser.id,
                                   "type": type.rawValue,
                                   "id": docRef.documentID,
                                   "profileImageUrl": currentUser.profileImageUrl,
                                   "fullname": currentUser.fullname]
        
        if let post = post {
            data["postId"] = post.id
        }
        
        docRef.setData(data)
    }
    
    static func deleteNotification(toUid uid: String, type: NotificationType, tweetId: String? = nil) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_NOTIFICATIONS.document(uid).collection("notifications")
            .whereField("uid", isEqualTo: currentUid).getDocuments { snapshot, _ in
                snapshot?.documents.forEach({ document in
                    let notification = Notification(dictionary: document.data())
                    guard notification.type == type else { return }
                    
                    if tweetId != nil {
                        guard tweetId == notification.postId else { return }
                    }
                    
                    document.reference.delete()
                })
            }
    }
    
    func fetchNotifications() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let query = COLLECTION_NOTIFICATIONS.document(uid).collection("notifications")
            .order(by: "timestamp", descending: true)
        
        query.getDocuments { snapshot, _ in
            guard let documents = snapshot?.documents else { return }
            self.notifications = documents.map({ Notification(dictionary: $0.data()) })
            
            self.fetchNotificationPosts()
            self.checkIfUserIsFollowed()
        }
    }
    
    func checkIfUserIsFollowed() {
        let followNotifications = notifications.filter({ $0.type == .follow })
        
        followNotifications.forEach { notification in
            UserService.checkIfUserIsFollowed(uid: notification.uid) { isFollowed in
                
                if let index = self.notifications.firstIndex(where: { $0.id == notification.id }) {
                    self.notifications[index].userIsFollowed = isFollowed
                }
            }
        }
    }
    
    private func fetchNotificationPosts() {
        let postNotifications = self.notifications.filter({ $0.postId != nil })
        
        postNotifications.forEach { notification in
            guard let postID = notification.postId else { return }
            
            COLLECTION_POSTS.document(postID).getDocument { snapshot, _ in
                guard let data = snapshot?.data() else { return }
                let post = Post(dictionary: data)
                                
                if let index = self.notifications.firstIndex(where: { $0.id == notification.id }) {
                    self.notifications[index].post = post
                }
            }
        }
    }
}
