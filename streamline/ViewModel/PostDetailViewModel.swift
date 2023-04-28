//
//  PostDetailViewModel.swift
//  streamline
//
//  Created by Sibtain Ali (Fiverr) on 28/04/2023.
//

import SwiftUI

class PostDetailViewModel: ObservableObject {
    
    
}


// MARK: - Api Functions
// MARK: -
extension PostDetailViewModel {
    
    func deletePost(post: Post, completion: @escaping (_ success: Bool)->()) {
        
        customAlertApple(title: "Delete Post", message: "Are you sure you want to delete this post?", showDestructive: true) { success in
            guard success else { completion(false); return }
            
            COLLECTION_POSTS.document(post.id).delete { error in
                
                // error
                guard error == nil else {
                    customAlert(message: error!.localizedDescription)
                    completion(false)
                    return
                }
                
                // success
                customAlert(message: "Post successfully deleted")
                
                completion(true)
                
            }
            
        }
        
    }
    
    
}


