//
//  Post.swift
//  streamline
//
//  Created by Matt Forgacs on 5/28/21.
//

import Firebase

struct Post: Identifiable {
    let id: String
    let profileImageUrl: String
    let fullname: String
    let caption: String
    let likes: String
    let uid: String
    let timestamp: Timestamp
    var replyingTo: String?
    var myGroupId: String
    var multiPostId: String
    var media: [MTMedia] = []

    init(dictionary: [String: Any]) {
        self.id = dictionary["id"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.caption = dictionary["caption"] as? String ?? ""
        self.likes = dictionary["likes"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        self.replyingTo = dictionary["replyingTo"] as? String
        self.myGroupId = dictionary["myGroupId"] as? String ?? ""
        self.multiPostId = dictionary["multiPostId"] as? String ?? ""
        let imagesURLs = dictionary["imagesURLs"] as? [String] ?? []
        self.media = imagesURLs.compactMap({MTMedia(imageURL: $0, mediaType: URL(string: $0)?.pathExtension == "mp4" ? .video : .photo, thumbnail: $0)})
    }
    
    var timestampString: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        return formatter.string(from: timestamp.dateValue(), to: Date()) ?? ""
    }
    
    var detailedTimestampString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a • MM/dd/yyyy"
        return formatter.string(from: timestamp.dateValue())
    }
}
