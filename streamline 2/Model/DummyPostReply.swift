//
//  DummyPostReply.swift
//  streamline
//
//  Created by Matt Forgacs on 6/15/21.
//

import Firebase

struct Replying: Identifiable {
    let id: String
    let profileImageUrl: String
    let fullname: String
    let caption: String
    let likes: Int
    let uid: String
//    var replyingTo: String?
    
    init(dictionary: [String: Any]) {
        self.id = dictionary["id"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.caption = dictionary["caption"] as? String ?? ""
        self.likes = dictionary["likes"] as? Int ?? 0
        self.uid = dictionary["uid"] as? String ?? ""
//        self.replyingTo = dictionary["replyingTo"] as? String ?? ""
    }
}
