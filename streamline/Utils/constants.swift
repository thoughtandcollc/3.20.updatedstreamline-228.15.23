//
//  constants.swift
//  streamline
//
//  Created by Matt Forgacs on 5/27/21.
//

import Firebase
import SafariServices

let COLLECTION_USERS = Firestore.firestore().collection("users")
let COLLECTION_FOLLOWERS = Firestore.firestore().collection("followers")
let COLLECTION_FOLLOWING = Firestore.firestore().collection("following")
let COLLECTION_POSTS = Firestore.firestore().collection("posts")
let COLLECTION_MESSAGES = Firestore.firestore().collection("messages")
let COLLECTION_READINGS = Firestore.firestore().collection("readings")
let COLLECTION_ANNOTATE = Firestore.firestore().collection("annotate")
let COLLECTION_NOTIFICATIONS = Firestore.firestore().collection("notifications")
let COLLECTION_CHAPTERS = Firestore.firestore().collection("chapters")
let COLLECTION_COMMENTS = Firestore.firestore().collection("comments")
let COLLECTION_GROUPS = Firestore.firestore().collection("groups")

let COMMENTS = "comments"

func getCurrentAndNextPostText(from value: String) -> (String, String) {
    var currentPost = String(value.prefix(120))
    let words = currentPost.byWords
    let lastWord = String(words.last ?? "")
    
    let index = value.index(value.startIndex, offsetBy: 120)
    var nextPostText = String(value.suffix(from: index))
    if currentPost.suffix(1) != " " && nextPostText.prefix(1) != " " {
        currentPost.removeWordFromString(wordToRemove: lastWord)
        nextPostText.insert(lastWord, index: 0)
    }
    return (currentPost, nextPostText)
}

func openBrowserWith(url: String) {
    
    guard let url = URL(string: url) else {
        return
    }
    let vc = SFSafariViewController(url: url)
    UIApplication.shared.windows.first?.rootViewController?.present(vc, animated: true, completion: nil)
}
