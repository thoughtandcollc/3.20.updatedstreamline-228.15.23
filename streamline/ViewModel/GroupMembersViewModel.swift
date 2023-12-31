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
    
    var tempGroup: Group // for editing only
    
    // initialization
    init(group: Group) {
        self.group = group
        tempGroup = group
        getMembers()
    }
    
}


// MARK: - Api Functions
// MARK: -
extension GroupMembersViewModel {
    
    func getMembers() {

        // show progress bar
        ProgressHUD.show()

        COLLECTION_USERS.whereField("uid", in: tempGroup.joinedUsers ?? []).getDocuments{[weak self] snapShot, error in
            guard let self = self else { return }
            
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
            
            for doc in docs {
                let user = User(dictionary: doc)
                members.append(user)
            }
            
            // update members list
            self.membersList = self.rearrangeMembers(members: members)

        }

    }
    
    func updateGroup() {
        
        // show progress bar
        ProgressHUD.show()
        
        // sending request in firebase
        COLLECTION_GROUPS.document(tempGroup.id).setData(tempGroup.toDictionary(), completion: {[weak self] error in
            
            guard let self = self else { return }
            
            // hide progress bar
            ProgressHUD.dismiss()
            
            // error
            guard error == nil else {
                customAlert(message: error!.localizedDescription)
                self.tempGroup = self.group
                return
            }
            
            // success
            customAlert(message: "Success", alertType: .success)
            
            // updating group
            self.group = self.tempGroup
            self.membersList = self.rearrangeMembers(members: membersList)
            
        })
        
    }
    
}


// MARK: - Getter Functions
// MARK: -
extension GroupMembersViewModel {
    
}


// MARK: - Action Functions
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
        
        customAlertSheetApple(title: "Change Member Role", message: "Do you want to change the role of this user?", option1: "Remove as Sub Leader", option2: "Remove user from group", option3: "Cancel") {  [weak self] option1, option2 in
            guard option1 || option2 else { return }
            guard let self = self else { return }
            
            // remove as sub leader
            if option1 {
                customAlertApple(title: "Remove as Sub Leader", message: "Are you sure you want to remove this member as sub leader?", showDestructive: true) { [weak self] success in
                    guard let self = self else { return }
                    guard success else { return }
                    
                    // remove as sub leader
                    self.tempGroup.subLeaders?.removeAll(where: { $0 == member.id })
                    
                    // update group in firebase
                    self.updateGroup()
                }
            }
            
            // remove member from group
            else if option2 {
                customAlertApple(title: "Remove Member", message: "Are you sure you want to remove this member from the group?", showDestructive: true) {[weak self] success in
                    guard success else { return }
                    guard let self = self else { return }
                    
                    // remove as sub leader
                    self.tempGroup.subLeaders?.removeAll(where: { $0 == member.id })
                    
                    // remove as member
                    self.tempGroup.joinedUsers?.removeAll(where: {$0 == member.id })
                    
                    // update group in firebase
                    self.updateGroup()
                    
                }
            }
            
        }
        
    }
    
    private func groupMemberTapped(member: User) {
        
        customAlertSheetApple(title: "Change Member Role", message: "Do you want to change the role of this member?", option1: "Make Sub Leader", option2: "Remove member from group", option3: "Cancel") { [weak self] option1, option2 in
            guard option1 || option2 else { return }
            guard let self = self else { return }
            
            // make user sub leader
            if option1 {
                customAlertApple(title: "Make Sub Leader", message: "Are you sure you want to make this member sub leader?", showDestructive: true) {[weak self] success in
                    guard let self = self else { return }
                    guard success else { return }
                    
                    // sub leaders count check
                    if tempGroup.subLeaders?.count ?? 0 >= 2 {
                        customAlert(message: "Only two members can be made sub leaders", alertType: .error)
                        return
                    }
                    
                    // add as sub leader
                    if tempGroup.subLeaders == nil { tempGroup.subLeaders = [] }
                    tempGroup.subLeaders?.append(member.id)
                    
                    // update group in firebase
                    updateGroup()
                    
                }
                
            }
            
            // remove user from group
            else if option2 {
                customAlertApple(title: "Remove Member", message: "Are you sure you want to remove this member from the group?", showDestructive: true) {[weak self] success in
                    guard success else { return }
                    guard let self = self else { return }
                    
                    // remove as sub leader
                    self.tempGroup.subLeaders?.removeAll(where: { $0 == member.id })
                    
                    // remove as member
                    self.tempGroup.joinedUsers?.removeAll(where: {$0 == member.id })
                    
                    // update group in firebase
                    self.updateGroup()
                    
                }
                
            }
            
        }
        
    }
    
}


// MARK: - Helper Functions
// MARK: -
extension GroupMembersViewModel {
    
    func rearrangeMembers(members: [User]) -> [User] {
        
        let owner = members.first(where: {$0.id == group.createdBy })
        
        let subLeaders = members
            .filter({group.subLeaders?.contains($0.id) ?? false })
            .sorted(by: {$0.fullname < $1.fullname })
        
        let otherMembers = members
            .filter({
            (group.subLeaders?.contains($0.id) ?? false == false)
            &&
            (group.createdBy != $0.id)
        })
            .sorted(by: {$0.fullname < $1.fullname })
        
        var sortedList = [User]()
        if let owner = owner { sortedList.append(owner)}
        sortedList.append(contentsOf: subLeaders)
        sortedList.append(contentsOf: otherMembers)
        
        return sortedList
        
    }
    
    
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
