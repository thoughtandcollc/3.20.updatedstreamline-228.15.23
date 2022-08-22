//
//  NotificationsViewModel.swift
//  streamline
//
//  Created by Tayyab Ali on 24/01/2022.
//

import SwiftUI
import FirebaseFirestore
import AlertToast

class NotificationViewModel: ObservableObject {
    @Published var notifications = [NotificationCellViewModel]()
    @Published var isLoading: Bool = false
    @Published var showToast: Bool = false
    @Published var alertToast = AlertToast(type: .regular, title: "SOME TITLE") {
        didSet{
            showToast.toggle()
        }
    }
    
    init() {
        fetchNotifications()
    }
    
    func fetchNotifications() {
        guard let uid = AuthViewModel.shared.userSession?.uid else { return }
        
        let query = COLLECTION_USERS.document(uid).collection("notifications")
            .order(by: "timestamp", descending: true)
        
        query.getDocuments { snapshot, _ in
            guard let documents = snapshot?.documents else { return }
            
            do {
                let notifications = try documents.compactMap({
                    try $0.data(as: AppNotification.self)
                })
                self.notifications = notifications.compactMap(NotificationCellViewModel.init)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func joinGroup(groupId: String) {
        guard let uid = AuthViewModel.shared.userSession?.uid else { return }
        
        let batch = Firestore.firestore().batch()
        
        // Save in User table
        let userCollectionQuery = COLLECTION_USERS.document(uid)
        batch.updateData(["joined_groups": FieldValue.arrayUnion([groupId])], forDocument: userCollectionQuery)
        
        // Save in Group table
        let groupCollectionQuery = COLLECTION_GROUPS.document(groupId)
        batch.updateData(["joinedUsers": FieldValue.arrayUnion([uid])], forDocument: groupCollectionQuery)
        
        isLoading = true
        batch.commit { error in
            self.isLoading = false
            
            if let error = error {
                self.alertToast = .init(type: .error(.red), title: error.localizedDescription)
                return
            }
            self.alertToast = .init(type: .complete(.orange), title: "Group Joined!")
            debugPrint("Group Joined!")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                AuthViewModel.shared.user?.joinedGroups.append(groupId)
            }
        }
        
//
//        isLoading = true
//
//        query.updateData(json) { error in
//            self.isLoading = false
//
//            if let error = error {
//                self.alertToast = .init(type: .error(.red), title: error.localizedDescription)
//                return
//            }
//            self.alertToast = .init(type: .complete(.orange), title: "Group Joined!")
//            debugPrint("Group Joined!")
//
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                AuthViewModel.shared.user?.joinedGroups.append(groupId)
//            }
//        }
    }
}
