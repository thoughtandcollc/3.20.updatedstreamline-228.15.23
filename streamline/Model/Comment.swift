//
//  Comment.swift
//  streamline
//
//  Created by Matt Forgacs on 12/14/21.
//

import Firebase

struct Comment: Identifiable {
    let commentText: String
    let user: User
    let fullName: String
    let toId: String
    let fromId: String
    let isFromCurrentUser: Bool
    let timestamp: Timestamp
    let id: String
    
    //    var rpcommentPartnerId: String { return isFromCurrentUser ? toId : fromId }
    
    init(user: User, dictionary: [String: Any]) {
        self.user = user
        self.commentText = dictionary["commentText"] as? String ?? ""
        self.toId = dictionary["toId"] as? String ?? ""
        self.fromId = dictionary["fromId"] as? String ?? ""
        self.isFromCurrentUser = fromId == Auth.auth().currentUser?.uid
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        self.id = dictionary["id"] as? String ?? ""
        self.fullName = dictionary["fullName"] as? String ?? ""
        
    }
    var timestampString: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        return formatter.string(from: timestamp.dateValue(), to: Date()) ?? ""
    }
}

