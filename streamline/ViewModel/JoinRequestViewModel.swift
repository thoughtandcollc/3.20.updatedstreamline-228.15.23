//
//  JoinRequestViewModel.swift
//  streamline
//
//  Created by Sibtain Ali (Fiverr) on 20/03/2023.
//

import SwiftUI
import FirebaseFirestore

class JoinRequestViewModel: ObservableObject {
    
    @Published var usersList: [User] = []
    @Published var group: Group
    
    // initialization
    init(group: Group) {
        self.group = group
        getUsers()
    }
    
}


// MARK: - Api Functions
// MARK: -
extension JoinRequestViewModel {
    
    func getUsers() {
        
        // show progress bar
        ProgressHUD.show()
        
        COLLECTION_USERS.whereField("uid", in: group.joinRequests ?? []).getDocuments{  snapShot, error in
            
            // hide progress bar
            ProgressHUD.dismiss()
            
            // error
            guard error == nil else {
                print("**** get data error: \(error?.localizedDescription ?? "")")
                return
            }
            
            // docs
            guard let snapShot = snapShot else { return }
            let docs = snapShot.documents

            // decode
            let users = docs.compactMap({ User(dictionary: $0.data()) })
            self.usersList = users
            
        }
        
    }
    
    
}


// MARK: - Getter Functions
// MARK: -
extension JoinRequestViewModel {
    
}


// MARK: - Helper Functions
// MARK: -
extension JoinRequestViewModel {
    
    func requestTapped(id: String, name: String) {
        
        dismissKeyboard()
        
        customAlertApple(title: "Accept Request?", message: "Would you like \(name) to join your group?", showDestructive: true) { success in
            
            var tempGroup = self.group
            
            // remove request
            tempGroup.joinRequests?.removeAll(where: { $0 == id })

            // if success, add user in joined users
            if success {
                tempGroup.joinedUsers?.append(id)
            }
            
            // removing duplicates
            tempGroup.joinedUsers = Array(Set(tempGroup.joinedUsers ?? []))
            
            // show progress bar
            ProgressHUD.show()
            
            // sending request in firebase
            COLLECTION_GROUPS.document(tempGroup.id).setData(tempGroup.toDictionary(), completion: { error in
                
                // hide progress bar
                ProgressHUD.dismiss()
                
                // error
                guard error == nil else {
                    customAlert(message: error!.localizedDescription)
                    return
                }
                
                // send notification to group owner
                self.sendNotification(receiverId: id)
                
                // success
                customAlert(message: "Request Accepted", alertType: .success)
                
                // updating group
                self.group.joinRequests = tempGroup.joinRequests
                self.group.joinedUsers = tempGroup.joinedUsers
                
            })
                     
        }
        
        
    }
    
    private func sendNotification(receiverId: String) {

        guard let sender = AuthViewModel.shared.user else { return }
        
        let query = COLLECTION_USERS.document(receiverId).collection("notifications").document()

        let notification = AppNotification(id: query.documentID,
                                           senderId: sender.id,
                                           username: sender.fullname,
                                           receiverId: receiverId,
                                           profileImageUrl: sender.profileImageUrl,
                                           type: .accepted,
                                           groupId: group.id,
                                           groupName: group.name,
                                           title: "Request Accepted",
                                           body: "Your request to join \(group.name) has been accepted.",
                                           timestamp: Timestamp(date: Date()))

        do {
            let _ = try query.setData(from: notification) { error in
                if let error = error {
                    debugPrint(error.localizedDescription)
                    return
                }
            }
        } catch {
            print(error.localizedDescription)
        }

    }

    
}

