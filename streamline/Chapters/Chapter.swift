//
//  SpecialUsers.swift
//  streamline
//
//  Created by Matt Forgacs on 9/24/21.
//

import Foundation
import Firebase

struct Chapter: Identifiable {
        let id: String
        let profileImageUrl: String
        let fullname: String
        let caption: String
        let likes: Int
        let uid: String
        let timestamp: Timestamp
 //       let replies: String
        
        init(dictionary: [String: Any]) {
            self.id = dictionary["id"] as? String ?? ""
            self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
            self.fullname = dictionary["fullname"] as? String ?? ""
            self.caption = dictionary["caption"] as? String ?? ""
            self.likes = dictionary["likes"] as? Int ?? 0
            self.uid = dictionary["uid"] as? String ?? ""
            self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
 //           self.replies = dictionary["replies"] as? String ?? ""
        }
}
