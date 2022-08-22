//
//  uploadMargin.swift
//  streamline
//
//  Created by Matt Forgacs on 10/7/21.
//

import SwiftUI
import Firebase

class uploadMargin: ObservableObject {
    @Binding var isPresented: Bool
    
  init(isPresented: Binding<Bool>) {
        self._isPresented = isPresented
    }
    

    func uploadMargin(reply: String) {
        guard let user = AuthViewModel.shared.user else { return }
        let docRef = COLLECTION_MARGIN.document()
        
        let data: [String: Any] = ["uid": user.id,
                                    "reply": reply,
                                     "fullname": user.fullname,
                                    "timestamp": Timestamp(date: Date()),
                                      "profileImageUrl": user.profileImageUrl,
                                      "likes": "0",
                                     "id": docRef.documentID]
                                    
        
        docRef.setData(data) { _ in }
            self.isPresented = false
    }
}
