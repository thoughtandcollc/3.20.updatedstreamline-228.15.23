//
//  uploadAnnotation.swift
//  streamline
//
//  Created by Matt Forgacs on 9/3/21.
//

import SwiftUI
import Firebase

class uploadAnnotations: ObservableObject {
    @Binding var isPresented: Bool
    
  init(isPresented: Binding<Bool>) {
        self._isPresented = isPresented
    }
    

    func uploadAnnotations(caption: String) {
        guard let user = AuthViewModel.shared.user else { return }
        let docRef = COLLECTION_ANNOTATE.document()
        
        let data: [String: Any] = ["uid": user.id,
                                    "caption": caption,
                                     "fullname": user.fullname,
                                    "timestamp": Timestamp(date: Date()),
                                      "profileImageUrl": user.profileImageUrl,
                                      "likes": "0",
                                     "id": docRef.documentID]
                                    
        
        docRef.setData(data) { _ in }
            self.isPresented = false
    }
}
