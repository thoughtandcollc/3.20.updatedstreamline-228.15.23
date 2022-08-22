//
//  FeedViewModel.swift
//  streamline
//
//  Created by Matt Forgacs on 5/28/21.
//

import SwiftUI
import FirebaseMessaging

class FeedViewModel: ObservableObject {
    private var allPosts = [Post]()
    @Published var feedPosts = [String : [Post]]()//[Post]()
//    private var groupPosts = [Post]()
    @Published var filteredGroupPosts = [String : [Post]]()//[Post]()
    var selectedGroupId = "" {
        didSet {
            filteredGroupPosts = selectedGroupId == "" ? [:] : Dictionary(grouping: allPosts.filter({$0.myGroupId == selectedGroupId}), by: {$0.multiPostId})
        }
    }

    @Published var showingCreateGroup = false
    
    init() {
        fetchPosts()
    }
    
    //made .snapshot listener instead of .getDocuments
    func fetchPosts() {
        
        COLLECTION_POSTS.addSnapshotListener { snapshot, _ in
            guard let documents = snapshot?.documents else { return }
            self.allPosts = documents.compactMap({ Post(dictionary: $0.data()) })
            self.allPosts = self.allPosts.sorted(by: { $0.timestamp.dateValue() > $1.timestamp.dateValue() })
            
            let feedPosts = self.allPosts.filter({$0.myGroupId.isEmpty})
            self.feedPosts = Dictionary(grouping: feedPosts, by: {$0.multiPostId})
            self.fetchGroupsPosts()
        }
    }
    
    func fetchGroupsPosts() {
//        guard let user = AuthViewModel.shared.user else {
//            return
//        }
        
        let filteredGroupPosts = allPosts.filter({$0.myGroupId == selectedGroupId})
        self.filteredGroupPosts = Dictionary(grouping: filteredGroupPosts, by: {$0.multiPostId})
    }
    
    func subscribeForPushNotification() {
        guard let userId = AuthViewModel.shared.userSession?.uid else {
            return
        }
        Messaging.messaging().subscribe(toTopic: userId) { error in
            print(error?.localizedDescription)
        }
    }
}



//db.collection("cities").document("SF")
//    .addSnapshotListener { documentSnapshot, error in
//      guard let document = documentSnapshot else {
//        print("Error fetching document: \(error!)")
//        return
//      }
//      guard let data = document.data() else {
//        print("Document data was empty.")
//        return
//      }
//      print("Current data: \(data)")
//    }

//    func fetchPosts() {
//        guard let uid = AuthViewModel.shared.userSession?.uid else { return }
//        var posts = [Post]()
//        COLLECTION_USERS.document(uid).collection("user-posts").getDocuments { snapshot, _ in
//            guard let documents = snapshot?.documents else { return }
//
//            documents.forEach { document in
//                COLLECTION_POSTS.document(document.documentID).getDocument { snapshot, _ in
//                    guard let data = snapshot?.data() else { return }
//                    posts.append(Post(dictionary: data))
//
//                    if posts.count == documents.count {
//                        self.posts = posts.sorted(by: { $0.timestamp.dateValue() > $1.timestamp.dateValue() })
//                    }
//                }
//            }
//        }
//    }
//}
