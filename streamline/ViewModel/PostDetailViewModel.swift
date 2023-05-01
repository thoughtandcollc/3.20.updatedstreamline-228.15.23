//
//  PostDetailViewModel.swift
//  streamline
//
//  Created by Sibtain Ali (Fiverr) on 28/04/2023.
//

import SwiftUI
import Firebase

class PostDetailViewModel: ObservableObject {
    
    @Published var group: Group?
    
    init(post: Post) {
        getGroup(groupId: post.myGroupId)
    }
    
}


// MARK: - Api Functions
// MARK: -
extension PostDetailViewModel {
    
    func getGroup(groupId: String) {
        
        COLLECTION_GROUPS.document(groupId).getDocument {[weak self] snapShot, error in
            
            guard let self = self else { return }
            
            // error
            guard error == nil else { return }
            
            do {
                self.group = try snapShot?.data(as: Group.self)
            }
            catch let error {
                printOnDebug(error.localizedDescription)
            }
        }
    }
    
    func deletePost(post: Post, completion: @escaping (_ success: Bool)->()) {
        
        customAlertApple(title: "Delete Post", message: "Are you sure you want to delete this post?", showDestructive: true) {[weak self] success in
            guard let self = self else { return }
            guard success else { completion(false); return }
            
            // delete photos first
            self.deletePhotosFromFirebase(post: post) { success in
                
                guard success else { return }
                
                // then delete post
                COLLECTION_POSTS.document(post.id).delete { error in
                    
                    // error
                    guard error == nil else {
                        customAlert(message: error!.localizedDescription)
                        completion(false)
                        return
                    }
                    
                    // success
                    customAlert(message: "Post successfully deleted", alertType: .success)
                    
                    completion(true)
                    
                }
                
            }
            
        }
        
    }
    
    private func deletePhotosFromFirebase(post: Post, completion: @escaping (_ success: Bool)-> Void) {
        
        // check media count
        guard post.media.count > 0 else { completion(true); return }
        
        let urls = post.media.map({ $0.imageURL })
        
        // for waiting till all images are deleted
        let manager = DispatchGroup()
        
        // delete all images one by one
        for url in urls {
            
            // enter queue
            manager.enter()
            
            // get firebase reference using the urls
            let ref = Storage.storage().reference(forURL: url)
            ref.delete { error in
                
                // check for error
                if error != nil {
                    print("error deleting post image: \(error!.localizedDescription)")
                }
                
                // leave queue
                manager.leave()
                
            }
        }
        
        // call completion once all image are deleted
        manager.notify(queue: .main) {
            completion(true)
        }
        
    }
    
    
}


