//
//  CreateGroupViewModel.swift
//  streamline
//
//  Created by Tayyab Ali on 18/01/2022.
//

import Foundation
import Firebase
import AlertToast
import UIKit

class CreateGroupViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var description: String = ""
    @Published var imageURL: URL?
    @Published var createNewGroup: Bool = false // create group or edit group
    @Published var alert: AlertIdentifier?
    @Published var showToast: Bool = false
    @Published var alertToast = AlertToast(type: .regular, title: "SOME TITLE") {
        didSet {
            showToast = true
        }
    }
        
    init(group: Group?) {
        
        // if group is nil then create new group if not then edit previous group
        guard let group = group else {
            createNewGroup = true // create new group instead of edit
            return
        }
        
        self.name               = group.name
        self.description        = group.description ?? " "
        self.imageURL           = URL(string : group.imageURL ?? "")
    }

    func createNewGroupInDatabase(image: UIImage?) {
        
       // guard let user = AuthViewModel.shared.user else { return }
        let groupId = UUID().uuidString
        
        guard let image = image else {
            self.alertToast = .init(type: .loading)
            self.saveDataToDatabase(imageURL: imageURL?.absoluteString ?? "", groupId: groupId)
            return
        }

        guard let imageData = image.jpegData(compressionQuality: 0.3) else { return }
        let storageRef = Storage.storage().reference().child("GroupsProfiles/\(groupId)")
        self.alertToast = .init(type: .loading)
        
        storageRef.putData(imageData, metadata: nil) { _, error in
            if let error = error {
                self.showToast = false
                print("DEBUG: Failed to upload image \(error.localizedDescription)")
                return
            }
                        
            storageRef.downloadURL { url, _ in
                guard let groupImageUrl = url?.absoluteString else { return }
                
                self.saveDataToDatabase(imageURL: groupImageUrl, groupId: groupId)
            }
        }
    }
    
    fileprivate func saveDataToDatabase(imageURL: String, groupId: String) {
        
        guard let user = AuthViewModel.shared.user else { return }
        
        let group = Group(id: groupId, name: name, description: description, imageURL: imageURL, timestamp: Timestamp(date: Date()), createdBy: user.id, joinedUsers: createNewGroup ? [user.id] : nil, joinRequests: [])
        
        let query = COLLECTION_GROUPS.document(groupId)

        do {
            let _ = try query.setData(from: group, merge: true) { error in
                self.showToast = false
                if let error = error {
                    self.alertToast =
                        .init(type: .error(.red), title: error.localizedDescription)
                    return
                }
                self.alert = .init(type: .success, message: "Group created successfully!")
            }
        } catch {
            print(error.localizedDescription)
            self.showToast = false
            self.alertToast = .init(type: .error(.red), title: error.localizedDescription)
        }
    }
}
