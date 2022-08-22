//
//  PostActionViewModel.swift
//  streamline
//
//  Created by Matt Forgacs on 5/29/21.
//

import SwiftUI
import Firebase

class PostActionViewModel: ObservableObject {
    let post: Post
    @Published var didLike = false
    
    init(post: Post) {
        self.post = post
        checkIfUserLikedPost()
    }
    
    func likePost() {
        guard let uid = AuthViewModel.shared.userSession?.uid else { return }
        let postLikesRef = COLLECTION_POSTS.document(post.id).collection("post-likes")
        let userLikesRef = COLLECTION_USERS.document(uid).collection("user-likes")
        
        COLLECTION_POSTS.document(post.id).updateData(["likes": post.likes + 1]) { _ in
            postLikesRef.document(uid).setData([:]) { _ in
                userLikesRef.document(self.post.id).setData([:]) { _ in
                    self.didLike = true
                    
                }
            }
        }
    }
    
    func unlikePost() {
        guard let uid = AuthViewModel.shared.userSession?.uid else { return }
        let postLikesRef = COLLECTION_POSTS.document(post.id).collection("post-likes")
        let userLikesRef = COLLECTION_USERS.document(uid).collection("user-likes")
        
        COLLECTION_POSTS.document(post.id).updateData(["likes": post.likes - 1]) { _ in
            postLikesRef.document(uid).delete() { _ in
                userLikesRef.document(self.post.id).delete() { _ in
                    self.didLike = false
                    
                }
            }
        }
        
    }
    
    func checkIfUserLikedPost() {
        guard let uid = AuthViewModel.shared.userSession?.uid else { return }
        let userLikesRef = COLLECTION_USERS.document(uid).collection("user-likes").document(post.id)
        
        
    userLikesRef.getDocument { snapshot, _  in
            guard let didLike = snapshot?.exists else { return }
            self.didLike = didLike
        }
    }
}
