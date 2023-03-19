//
//  Group.swift
//  streamline
//
//  Created by Tayyab Ali on 18/01/2022.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

struct Group: Codable, Identifiable, Hashable {
    var id: String = ""
    var name: String = ""
    var description: String?
    var imageURL: String?
    var timestamp: Timestamp = Timestamp(date: Date())
    var joinedUsers: [String]?
    
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
    
    init() {
        
    }
    
    internal init(id: String = "", name: String = "", description: String? = nil, imageURL: String? = nil, timestamp: Timestamp, joinedUsers: [String]?) {
        self.id = id
        self.name = name
        self.description = description
        self.imageURL = imageURL
        self.timestamp = timestamp
        self.joinedUsers = joinedUsers
    }
}
