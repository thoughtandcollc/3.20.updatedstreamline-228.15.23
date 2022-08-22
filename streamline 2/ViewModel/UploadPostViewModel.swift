//
//  UploadPostViewModel.swift
//  streamline
//
//  Created by Matt Forgacs on 5/28/21.
//

import SwiftUI
import Firebase

class UploadPostViewModel: ObservableObject {
    @Binding var isPresented: Bool
    
    init(isPresented: Binding<Bool>) {
        self._isPresented = isPresented
    }
    

    func uploadPost(caption: String) {
        guard let user = AuthViewModel.shared.user else { return }
        let docRef = COLLECTION_POSTS.document()
        
        let data: [String: Any] = ["uid": user.id,
                                   "caption": caption,
                                   "fullname": user.fullname,
                                   "timestamp": Timestamp(date: Date()),
                                   "profileImageUrl": user.profileImageUrl,
                                   "likes": "0",
                                   "id": docRef.documentID]
        
        docRef.setData(data) { _ in }
            print("DEBUG: Successfully Uploaded Post")
            self.isPresented = false
    }
}
