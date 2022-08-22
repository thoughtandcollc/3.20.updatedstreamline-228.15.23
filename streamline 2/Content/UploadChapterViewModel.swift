//
//  UploadChapterViewModel.swift
//  streamline
//
//  Created by Matt Forgacs on 9/25/21.
//

import SwiftUI
import Firebase

class UploadChapterViewModel: ObservableObject {
    @Binding var isPresented: Bool
    
    init(isPresented: Binding<Bool>) {
        self._isPresented = isPresented
    }
    

    func uploadChapter(caption: String) {
        guard let user = AuthViewModel.shared.user else { return }
        let docRef = COLLECTION_CHAPTERS.document()
        
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
