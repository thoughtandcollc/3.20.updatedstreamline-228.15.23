//
//  FeedViewModel.swift
//  streamline
//
//  Created by Matt Forgacs on 5/28/21.
//

import SwiftUI

class FeedViewModel: ObservableObject {
    @Published var posts = [Post]()
    
    init() {
        fetchPosts()
    }

    func fetchPosts() {
            COLLECTION_POSTS.getDocuments { snapshot, _ in
                guard let documents = snapshot?.documents else { return }
                self.posts = documents.map({ Post(dictionary: $0.data()) })
                self.posts = self.posts.sorted(by: { $0.timestamp.dateValue() < $1.timestamp.dateValue() })
                        }
                    }

}

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
