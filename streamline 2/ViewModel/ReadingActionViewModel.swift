//
//  ReadingActionViewModel.swift
//  streamline
//
//  Created by Matt Forgacs on 6/17/21.
//

import SwiftUI
import Firebase

class ReadingActionViewModel: ObservableObject {
    let reading: Reading
    @Published var didLike = false
    
    init(reading: Reading) {
        self.reading = reading
        checkIfUserLikedReading()
    }
    
    func likeReading() {
        guard let uid = AuthViewModel.shared.userSession?.uid else { return }
        let readingLikesRef = COLLECTION_READINGS.document(reading.id).collection("reading-likes")
        let userLikesRef = COLLECTION_USERS.document(uid).collection("user-likes")
        
        COLLECTION_READINGS.document(reading.id).updateData(["likes": reading.likes + 1]) { _ in
            readingLikesRef.document(uid).setData([:]) { _ in
                userLikesRef.document(self.reading.id).setData([:]) { _ in
                    self.didLike = true
                    
                }
            }
        }
    }
    
    func unlikeReading() {
        guard let uid = AuthViewModel.shared.userSession?.uid else { return }
        let readingLikesRef = COLLECTION_READINGS.document(reading.id).collection("reading-likes")
        let userLikesRef = COLLECTION_USERS.document(uid).collection("user-likes")
        
        COLLECTION_READINGS.document(reading.id).updateData(["reading-likes": reading.likes - 1]) { _ in
            readingLikesRef.document(uid).delete() { _ in
                userLikesRef.document(self.reading.id).delete() { _ in
                    self.didLike = false
                    
                }
            }
        }
        
    }
    
    func checkIfUserLikedReading() {
        guard let uid = AuthViewModel.shared.userSession?.uid else { return }
        let userLikesRef = COLLECTION_USERS.document(uid).collection("reading-likes").document(reading.id)
        
        
    userLikesRef.getDocument { snapshot, _  in
            guard let didLike = snapshot?.exists else { return }
            self.didLike = didLike
        }
    }
}

