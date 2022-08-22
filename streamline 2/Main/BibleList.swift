//
//  BibleList.swift
//  streamline
//
//  Created by Matt Forgacs on 8/2/21.
//

import SwiftUI

struct Bible: Identifiable {
    let id = UUID()
    let imageName: String
    let title: String
    let description: String
    let viewCount: Int
    let uploadDate: String
    let dueDate: String
    let url: URL
}

struct BibleList {
    
    static let upcomingReadings = [
        Bible(imageName: "Focus1", title: "Adam & Eve", description: "The Biblical story of Adam and Eve is told in the book of Genesis, when God created Adam, and then Eve. Share any comments, ideas, or thoughts as you read the story of creation.", viewCount: 350000, uploadDate: "August 5th, 2021", dueDate: "Due August 5th, 2021", url: URL(string: "https://www.biblegateway.com/passage/?search=Genesis+2%3A4-3%3A24&version=ASV")!),
        
        Bible(imageName: "Focus2", title: "Noah's Ark", description: "Noah's Ark is the vessel in the Genesis flood narrative through which God spares Noah, his family, and examples of all the world's animals from a world-engulfing flood.", viewCount: 545000, uploadDate: "August 5th, 2021", dueDate: "Due August 6th, 2021", url: URL(string: "https://www.biblegateway.com/passage/?search=Genesis+5%3A32-10%3A1&version=ASV")!),
        
        Bible(imageName: "Focus3", title: "Jonah and the Whale", description: "The primary theme of the story of Jonah and the Whale is that God's love, grace, and compassion extend to everyone, even outsiders and oppressors. God loves all people.", viewCount: 890100, uploadDate: "August 5th, 2021", dueDate: "Due August 7th, 2021", url: URL(string: "https://www.biblegateway.com/passage/?search=Jonah+1-4&version=ASV")!),
        
        Bible(imageName: "Focus4", title: "David and Goliath", description: "David and Goliath is often referenced as a moral lesson of how underdogs can overcome the odds and be successful. The phrase “David strategies” has been used to describe what underdogs have to do to overcome Goliaths or favorites, in business, sports and life.", viewCount: 150500, uploadDate: "August 5th, 2021", dueDate: "Due August 8th, 2021", url: URL(string: "https://www.biblegateway.com/passage/?search=1+Samuel+17&version=ASV")!),
        
        Bible(imageName: "Focus5", title: "Cain & Abel", description: "In the biblical Book of Genesis, Cain and Abel are the first two sons of Adam and Eve. Cain, the firstborn, was a farmer, and his brother Abel was a shepherd.", viewCount: 1090000, uploadDate: "August 5th, 2021", dueDate: "Due August 9th, 2021", url: URL(string: "https://www.biblegateway.com/passage/?search=Genesis+4&version=ASV")!),
        
              Bible(imageName: "Focus6", title: "The Exodus", description: "“Exodus” means exiting, and the book of Exodus tells of the escape from Egypt led by Moses and covers the 40 years of wandering in the wilderness.", viewCount: 492100, uploadDate: "August 5th, 2021", dueDate: "Due August 10th, 2021", url: URL(string: "https://www.biblegateway.com/passage/?search=Exodus+1&version=ASV")!),
        
        Bible(imageName: "Focus7", title: "The Miracle", description: "Jesus walking on the water, or on the sea, is depicted as one of the miracles of Jesus recounted in the New Testament.", viewCount: 90300, uploadDate: "August 5th, 2021", dueDate: "Due August 11th, 2021", url: URL(string: "https://www.biblegateway.com/passage/?search=Matthew+14%3A22-33&version=ASV")!)
    
    ]
    
}
