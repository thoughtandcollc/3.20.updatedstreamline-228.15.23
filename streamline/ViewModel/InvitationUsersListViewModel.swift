//
//  InvitationUsersListViewModel.swift
//  streamline
//
//  Created by Tayyab Ali on 25/01/2022.
//

import FirebaseFirestore
import AlertToast
import SwiftUI

class InvitationUsersListViewModel: ObservableObject {
    @Published var users: [InvitationCellViewModel] = []
    @Published var isLoading: Bool = false
    @Published var showToast: Bool = false
    @Published var alertToast = AlertToast(type: .regular, title: "SOME TITLE") {
        didSet{
            showToast.toggle()
        }
    }
    private var myGroup: Group
    
    init(myGroup: Group) {
        self.myGroup = myGroup
    }
    
    func fetchUsers() {
        guard let uid = AuthViewModel.shared.userSession?.uid else { return }
        isLoading = true
        
        COLLECTION_USERS.getDocuments { snapshots, error in
            self.isLoading = false
            
            if let error = error {
                self.alertToast = .init(type: .error(.red), title: error.localizedDescription)
                return
            }
            
            let users = snapshots?.documents.compactMap({User(dictionary: $0.data())})
            self.users = (users?.filter({$0.id != uid}) ?? []).compactMap({InvitationCellViewModel($0, myGroupId: self.myGroup.id)})
        }
    }
    
    func inviteUser(toUid uid: String, success: @escaping()-> Void) {
        guard let currentUser = AuthViewModel.shared.user else { return }
        
        let query = COLLECTION_USERS.document(uid).collection("notifications").document()
        
        let notification = AppNotification(id: query.documentID,
                                           senderId: currentUser.id,
                                           username: currentUser.fullname,
                                           receiverId: uid,
                                           profileImageUrl: currentUser.profileImageUrl,
                                           type: .invite,
                                           groupId: myGroup.id,
                                           groupName: myGroup.name,
                                           title: "Group Invitation",
                                           body: "\(currentUser.fullname) sent you an invitation to join group.",
                                           timestamp: Timestamp(date: Date()))
        
        isLoading = true
        
        do {
            let _ = try query.setData(from: notification) { error in
                self.isLoading = false
                if let error = error {
                    self.alertToast = .init(type: .error(.red), title: error.localizedDescription)
                    return
                }
                
                self.alertToast = .init(type: .complete(.orange), title: "Invitation sent!")
                success()
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
