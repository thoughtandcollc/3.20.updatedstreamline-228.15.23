//
//  GetGroupViewModel.swift
//  streamline
//
//  Created by Tayyab Ali on 24/01/2022.
//

import Foundation
import Firebase
import UIKit

class GetGroupViewModel: ObservableObject {
    
    @Published var joinedGroups = [Group]() // other groups that the user has joined
    @Published var myGroups     = [Group]() // groups created by the user

    private var groupsListener: ListenerRegistration? // listener for group changes
    
    init() {
        fetchMyGroups()
    }
    
    deinit {
        groupsListener?.remove()
    }
    
}

// MARK: - Helper Functions
// MARK: -
extension GetGroupViewModel {
    
    func fetchMyGroups() {
        
        // get user id
        guard let user = AuthViewModel.shared.user else { return }
        
        // set query
        let query = COLLECTION_GROUPS.whereField("joinedUsers", arrayContains: user.id)

        // set listener for user groups
        groupsListener = query.addSnapshotListener{ snapshot, error in
            
            // error handling
            guard error == nil else {
                customAlert(message: error!.localizedDescription)
                print("Error while fetching my group => \(error!.localizedDescription)")
                return
            }
            
            // get documents
            guard let documents = snapshot?.documents else {
                return
            }
            
            do {
                
                // save fetched groups in groups struct array
                var groups = try documents.compactMap({
                    try $0.data(as: Group.self)
                })
                
                // filter created groups
                self.myGroups = groups.filter({ $0.createdBy == userId })
                
                // filter joined groups
                self.joinedGroups = groups.filter({ $0.createdBy != userId })
                
                // move my groups to front at first
                self.joinedGroups.insert(contentsOf: self.myGroups, at: 0)
                
            }
            catch let error {
                customAlert(message: error.localizedDescription)
                print(error.localizedDescription)
            }
            
        }
    }
    
}
