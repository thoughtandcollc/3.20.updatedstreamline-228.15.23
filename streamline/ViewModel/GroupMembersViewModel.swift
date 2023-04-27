//
//  GroupMembersViewModel.swift
//  streamline
//
//  Created by Sibtain Ali (Fiverr) on 26/04/2023.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

class GroupMembersViewModel: ObservableObject {
    
    @Published var group: Group
    @Published var membersList: [User] = []
    
    // initialization
    init(group: Group) {
        self.group = group
        getMembers()
    }
    
}


// MARK: - Api Functions
// MARK: -
extension GroupMembersViewModel {
    
    func getMembers() {

        // show progress bar
        ProgressHUD.show()

        COLLECTION_USERS.whereField("uid", in: group.joinedUsers ?? []).getDocuments{ snapShot, error in

            // hide progress bar
            ProgressHUD.dismiss()

            // error
            guard error == nil else {
                print("**** get data error: \(error?.localizedDescription ?? "")")
                return
            }

            // docs
            guard let snapShot = snapShot else { return }
            let docs = snapShot.documents.map({ $0.data() })

            var members = [User]()
            var owner: User?
            var subAdmins = [User]()
            
            
            for doc in docs {
                
                let user = User(dictionary: doc)
                
                // owner
                if user.id == self.group.createdBy {
                    owner = user
                }
                // other members
                else {
                    members.append(user)
                }
                
            }
            
            // insert owner at the top of the array
            if let owner = owner {
                members.insert(owner, at: 0)
            }
            
            // update members list
            self.membersList = members

        }

    }
    
//    func joinGroup(group: Group) {
//
//        customAlertApple(title: "Join Group?", message: "Would you like to send request to join this group?", showDestructive: true) { success in
//
//            // check if user tapped yes
//            guard success else { return }
//
//            // get user id
//            guard let userId = Auth.auth().currentUser?.uid else { return }
//            var newGroup = group
//
//            // adding user id in join requests
//            if newGroup.joinRequests == nil {
//                newGroup.joinRequests = [userId]
//            }
//            else {
//                newGroup.joinRequests?.append(userId)
//            }
//
//            // removing duplicates
//            newGroup.joinRequests = Array(Set(newGroup.joinRequests ?? []))
//
//            // show progress bar
//            ProgressHUD.show()
//
//            // sending request in firebase
//            COLLECTION_GROUPS.document(group.id).setData(newGroup.toDictionary(), completion: { error in
//
//                // hide progress bar
//                ProgressHUD.dismiss()
//
//                // error
//                guard error == nil else {
//                    customAlert(message: error!.localizedDescription)
//                    return
//                }
//
//                // success
//                customAlert(message: "Request Successfully Sent", alertType: .success)
//
//                // updating group
//                guard let index = self.groupsList.firstIndex(where: {$0.id == group.id }) else { return }
//                self.groupsList[index].joinRequests = newGroup.joinRequests
//
//            })
//
//
//        }
//    }
    
//    func leaveGroup(group: Group) {
//
//        customAlertApple(title: "Leave Group?", message: "Would you like leave this group?", showDestructive: true) { success in
//
//            // check if user tapped yes
//            guard success else { return }
//
//            // get user id
//            guard let userId = Auth.auth().currentUser?.uid else { return }
//            var newGroup = group
//
//            // remove user id from joined users
//            newGroup.joinedUsers?.removeAll(where: { $0 == userId })
//
//            // show progress bar
//            ProgressHUD.show()
//
//            // sending request in firebase
//            COLLECTION_GROUPS.document(newGroup.id).setData(newGroup.toDictionary(), completion: { error in
//
//                // hide progress bar
//                ProgressHUD.dismiss()
//
//                // error
//                guard error == nil else {
//                    customAlert(message: error!.localizedDescription)
//                    return
//                }
//
//                // success
//                customAlert(message: "Group Left", alertType: .success)
//
//                // updating group
//                guard let index = self.groupsList.firstIndex(where: {$0.id == newGroup.id }) else { return }
//                self.groupsList[index].joinedUsers = newGroup.joinedUsers
//
//            })
//
//
//        }
//    }

    
}


// MARK: - Getter Functions
// MARK: -
extension GroupMembersViewModel {
    
}


// MARK: - Helper Functions
// MARK: -
extension GroupMembersViewModel {
    
    func memberTapped(member: User) {
        
        // return if owner is tapped
        guard isGroupOwner(memberId: member.id, group: group) == false else { return }
        
        dismissKeyboard()
        
        // if current signed is user is owner of the group
        if isGroupOwner(memberId: userId, group: group) {
            
            // if sub leader is tapped
            if isGroupSubLeader(memberId: member.id, group: group) {
                groupSubLeaderTapped(member: member)
            }
            // if normal user is tapped
            else {
                groupMemberTapped(member: member)
            }
            
        }
        
        // if current signed in user is sub leader is owner of the group
        else if isGroupSubLeader(memberId: userId, group: group){
            
            // if is sub leader is tapped
            if isGroupSubLeader(memberId: member.id, group: group) {
                // do nothing as sub leader can not do any action on other sub leaders
            }
            
            // if normal user if tapped
            else {
                groupMemberTapped(member: member)
            }
            
        }
        
        
    }
    
    private func groupSubLeaderTapped(member: User) {
        
        customAlertSheetApple(title: "Change Member Role", message: "Do you want to change the role of this user?", option1: "Remove as Sub Leader", option2: "Remove user from group", option3: "Cancel") { option1, option2 in
            guard option1 || option2 else { return }
            
            // remove as sub leader
            if option1 {
                
            }
            
            // remove user from group
            else if option2 {
                
            }
            
        }
        
    }
    
    private func groupMemberTapped(member: User) {
        
        customAlertSheetApple(title: "Change Member Role", message: "Do you want to change the role of this user?", option1: "Make user Sub Leader", option2: "Remove user from group", option3: "Cancel") { option1, option2 in
            guard option1 || option2 else { return }
            
            // make user sub leader
            if option1 {
                
            }
            
            // remove user from group
            else if option2 {
                
            }
            
        }
        
    }
    
    

    
}


// MARK: - Helper Functions
// MARK: -
extension GroupMembersViewModel {
    
    
    func customAlertSheetApple(title: String,
                               message: String,
                               option1: String = "Yes",
                               option2: String = "No",
                               option3: String = "Cancel",
                               completion: ((_ option1: Bool, _ option2: Bool) -> Void)? = nil) {

        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.actionSheet)

        let option1Action = UIAlertAction(title: option1, style: .default, handler: { (alert) in
            completion?(true, false)
        })
        
        let option2Action = UIAlertAction(title: option2, style: .default, handler: { (alert) in
            completion?(false, true)
        })

        let option3Action = UIAlertAction(title: option3, style: .cancel, handler: { (alert) in
            completion?(false, false)
        })

        alertController.addAction(option1Action)
        alertController.addAction(option2Action)
        alertController.addAction(option3Action)
        alertController.modalPresentationStyle = .overFullScreen

        var vc = rootVC
        if let tempVC = vc?.presentedViewController { vc = tempVC }
        vc?.present(alertController, animated: true, completion: nil)

    }
}
