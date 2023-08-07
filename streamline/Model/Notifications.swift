//
//  Notifications.swift
//  streamline
//
//  Created by Matt Forgacs on 9/20/21.
//

//import SwiftUI
import FirebaseFirestoreSwift
import FirebaseFirestore

struct AppNotification: Codable, Identifiable {
    var id: String = ""
    var senderId: String = ""
    var username: String = ""
    var receiverId: String = ""
    var profileImageUrl: String = ""
    var type: NotificationType = .invite
    var postId: String?
    var groupId: String?
    var groupName: String?
    var title: String = ""
    var body: String = ""
//    var post: Post?
//    var userIsFollowed = false
    var timestamp: Timestamp

//
//    init(dictionary: [String: Any]) {
//        self.id = dictionary["id"] as? String ?? ""
//        self.uid = dictionary["uid"] as? String ?? ""
//        self.username = dictionary["username"] as? String ?? ""
//        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
//        self.type = NotificationType(rawValue: dictionary["type"] as? Int ?? 0) ?? .like
//
//        if let postId = dictionary["postId"] as? String {
//            self.postId = postId
//        }
//        self.groupId = dictionary["groupId"] as? String
//        self.groupName = dictionary["groupName"] as? String
//    }
}

enum NotificationType: Int, Codable {
    case like = 0
    case reply
    case follow
    case invite
    case comment
    case join
    case accepted
    
    var notificationText: String {
        switch self {
        case .like: return " liked one of your tweets"
        case .reply: return " replied to one of your tweets"
        case .follow: return " started following you"
        case .invite: return " invited you to join group. Tap to join."
        case .comment: return " comment on your post"
        case .join: return " would like to join your group"
        case .accepted: return " accepted your request"
        }
    }
}
