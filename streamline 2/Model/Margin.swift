//
//  Margin.swift
//  streamline
//
//  Created by Matt Forgacs on 10/5/21.
//

import Foundation
import Firebase

struct Margin: Identifiable {
      //  let user: User
        let id: String
        let profileImageUrl: String
        let fullname: String
        let reply: String
   //     let toId: String
  //      let fromId: String
   //     let isFromCurrentUser: Bool
        let uid: String
        let timestamp: Timestamp
 //       let replies: String
        
    init(dictionary: [String: Any]) {
            self.id = dictionary["id"] as? String ?? ""
            self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
            self.fullname = dictionary["fullname"] as? String ?? ""
            self.reply = dictionary["reply"] as? String ?? ""
//            self.toId = dictionary["toId"] as? String ?? ""
//            self.fromId = dictionary["fromId"] as? String ?? ""
//            self.isFromCurrentUser = fromId == Auth.auth().currentUser?.uid
            self.uid = dictionary["uid"] as? String ?? ""
            self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
    //        self.user = user
 //           self.replies = dictionary["replies"] as? String ?? ""
        }
}
