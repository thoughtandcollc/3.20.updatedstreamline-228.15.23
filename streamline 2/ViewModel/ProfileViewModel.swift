//
//  ProfileViewModel.swift
//  streamline
//
//  Created by Matt Forgacs on 5/28/21.
//

import SwiftUI
import Firebase

class ProfileViewModel: ObservableObject {
    @Published var user: User
    @Published var userPosts = [Post]()
    @Published var likedPosts = [Post]()
    @Published var replies = [Post]()
    
    init(user: User) {
        self.user = user
        checkIfUserIsFollowed()
        fetchUserPosts()
        fetchLikedPosts()
        fetchUserStats()
    }
    
    
    func posts(ForFilter filter: PostFilterOptions) -> [Post] {
        switch filter {
        case .posts: return userPosts
        case .likes: return likedPosts
    //    case .replies: return replies
        }
    }
}
// MARK: - API

extension ProfileViewModel {
    func follow() {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        let followingRef = COLLECTION_FOLLOWING.document(currentUid).collection("user-following")
        let followersRef = COLLECTION_FOLLOWERS.document(user.id).collection("user-follwers")
        
        followingRef.document(user.id).setData([:]) { _ in
            followersRef.document(currentUid).setData([:]) { _ in
                self.user.isFollowed = true
            }
        }
    }
    
    func unfollow() {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        let followingRef = COLLECTION_FOLLOWING.document(currentUid).collection("user-following")
        let followersRef = COLLECTION_FOLLOWERS.document(user.id).collection("user-follwers")
        
        followingRef.document(user.id).delete() { _ in
            followersRef.document(currentUid).delete { _ in
                self.user.isFollowed = false
            }
            
        }
        
    }
    func checkIfUserIsFollowed() {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        guard !user.isCurrentUser else { return }
        let followingRef = COLLECTION_FOLLOWING.document(currentUid).collection("user-following")
        
        followingRef.document(user.id).getDocument { snapshot, _ in
            guard let isFollowed = snapshot?.exists else { return }
            self.user.isFollowed = isFollowed
        }
    }
    
    func fetchUserPosts() {
        COLLECTION_POSTS.whereField("uid", isEqualTo: user.id).getDocuments { snapshot, _ in
            guard let documents = snapshot?.documents else { return }
            self.userPosts = documents.map({ Post(dictionary: $0.data())})
            
            print("DEBUG: User posts \(self.userPosts)")
        }
    }
    
    func fetchLikedPosts() {
        var posts = [Post]()
        COLLECTION_USERS.document(user.id).collection("user-likes").getDocuments { snashot, _ in
            guard let documents = snashot?.documents else { return }
            let postIDs = documents.map({ $0.documentID })
            
            postIDs.forEach { id in
                COLLECTION_POSTS.document(id).getDocument { snapshot, _ in
                    guard let data = snapshot?.data() else { return }
                    let post = Post(dictionary: data)
                    posts.append(post)
                    guard posts.count == postIDs.count else { return }
                    
                    self.likedPosts = posts
                }
                
            }
        }
    }
    
    func fetchUserStats() {
        let followersRef = COLLECTION_FOLLOWERS.document(user.id).collection("user-followers")
        let followingRef = COLLECTION_FOLLOWING.document(user.id).collection("user-following")

        
        followersRef.getDocuments { snapshot, _ in
           guard let followerCount = snapshot?.documents.count else { return }
            
            followingRef.getDocuments { snapshot, _ in
                guard let followingCount = snapshot?.documents.count else { return }
                
                self.user.stats = UserStats(followers: followerCount, following: followingCount)
            }
        }
    }
}
