//
//  Object.swift
//  streamline
//
//  Created by Matt Forgacs on 5/27/21.
//

import Firebase

struct User: Identifiable {
    let id: String
    let profileImageUrl: String
    let fullname: String
    let email: String
    var stats: UserStats
    var joinedGroups: [String]
    var isFollowed = false
    var isCurrentUser: Bool { return Auth.auth().currentUser?.uid == self.id }
    
    init(dictionary: [String: Any]) {
        self.id = dictionary["uid"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.stats = UserStats(followers: 0, following: 0)
        self.joinedGroups = dictionary["joined_groups"] as? [String] ?? []
    }
}

struct UserStats {
    let followers: Int
    let following: Int
}
