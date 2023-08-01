//
//  SearchGroupViewModel.swift
//  streamline
//
//  Created by Sibtain Ali (Fiverr) on 17/03/2023.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

class SearchGroupViewModel: ObservableObject {
    
    @Published var groupsList: [Group] = []
    @Published var selectedGroup: Group = Group()
    
    // initialization
    init() {
        getGroups()
    }
    
}


// MARK: - Api Functions
// MARK: -
extension SearchGroupViewModel {
    
    func getGroups() {
        
        // show progress bar
        ProgressHUD.show()
        
        COLLECTION_GROUPS.getDocuments {  snapShot, error in
            
            // hide progress bar
            ProgressHUD.dismiss()
            
            // error
            guard error == nil else {
                print("**** get data error: \(error?.localizedDescription ?? "")")
                return
            }
            
            // docs
            guard let snapShot = snapShot else { return }
            let docs = snapShot.documents//.map({ $0.data() })

            // decode
            do {
                let groups = try docs.compactMap({ try $0.data(as: Group.self) })
                self.groupsList = groups
            } catch {
                print(error.localizedDescription)
            }
            
        }
        
    }
    
    func joinGroup(group: Group) {
        
        customAlertApple(title: "Join Group?", message: "Would you like to send request to join this group?", showDestructive: true) { success in
            
            // check if user tapped yes
            guard success else { return }
            
            // get user id
            guard let userId = Auth.auth().currentUser?.uid else { return }
            var newGroup = group
            
            // adding user id in join requests
            if newGroup.joinRequests == nil {
                newGroup.joinRequests = [userId]
            }
            else {
                newGroup.joinRequests?.append(userId)
            }
            
            // removing duplicates
            newGroup.joinRequests = Array(Set(newGroup.joinRequests ?? []))
            
            // show progress bar
            ProgressHUD.show()
            
            // sending request in firebase
            COLLECTION_GROUPS.document(group.id).setData(newGroup.toDictionary(), completion: { error in
                
                // hide progress bar
                ProgressHUD.dismiss()
                
                // error
                guard error == nil else {
                    customAlert(message: error!.localizedDescription)
                    return
                }
                
                // success
                customAlert(message: "Request Successfully Sent", alertType: .success)
                
                // updating group
                guard let index = self.groupsList.firstIndex(where: {$0.id == group.id }) else { return }
                self.groupsList[index].joinRequests = newGroup.joinRequests
                
            })
                
                
        }
    }
    
    func leaveGroup(group: Group) {
        
        customAlertApple(title: "Leave Group?", message: "Would you like leave this group?", showDestructive: true) { success in
            
            // check if user tapped yes
            guard success else { return }
            
            // get user id
            guard let userId = Auth.auth().currentUser?.uid else { return }
            var newGroup = group
            
            // remove user id from joined users
            newGroup.joinedUsers?.removeAll(where: { $0 == userId })
            
            // show progress bar
            ProgressHUD.show()
            
            // sending request in firebase
            COLLECTION_GROUPS.document(newGroup.id).setData(newGroup.toDictionary(), completion: { error in
                
                // hide progress bar
                ProgressHUD.dismiss()
                
                // error
                guard error == nil else {
                    customAlert(message: error!.localizedDescription)
                    return
                }
                
                // success
                customAlert(message: "Group Left", alertType: .success)
                
                // updating group
                guard let index = self.groupsList.firstIndex(where: {$0.id == newGroup.id }) else { return }
                self.groupsList[index].joinedUsers = newGroup.joinedUsers
                
            })
                
                
        }
    }

    
}


// MARK: - Getter Functions
// MARK: -
extension SearchGroupViewModel {
    
    func getRequestStatus() -> String {
        
        if selectedGroup.joinedUsers?.contains(userId) ?? false {
           return "Joined"
        }
        else if selectedGroup.joinRequests?.contains(userId) ?? false {
            return "Request Sent"
        }
        else {
            return "Join Group?"
        }
        
    }
    
}


// MARK: - Helper Functions
// MARK: -
extension SearchGroupViewModel {
    
    func groupTapped() {
        
        guard selectedGroup.name.isNotEmpty else { return }
        let group = selectedGroup
        
        // return if user has already sent request to join or its users group
        if group.joinRequests?.contains(userId) ?? false
            || group.createdBy == userId { return }
        
        dismissKeyboard()
        
        if group.joinedUsers?.contains(userId) ?? false {
            leaveGroup(group: group)
        }
        else {
            joinGroup(group: group)
        }
        
    }
    
}

