//
//  GetGroupViewModel.swift
//  streamline
//
//  Created by Tayyab Ali on 24/01/2022.
//

import Foundation
import UIKit

class GetGroupViewModel: ObservableObject {
    @Published var myGroups = [Group]()
    @Published var myGroup: Group?
    var isAlreadyHaveGroup: Bool = false

    init() {
        fetchMyGroups()
    }
    
    func fetchMyGroups() {
        guard let user = AuthViewModel.shared.user else { return }
        let query = COLLECTION_GROUPS.whereField("joinedUsers", arrayContains: user.id)

        query.addSnapshotListener{ snapshot, error in
            if let error = error {
                print("Error while fetching my group => \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else {
                return
            }
            
            do {
                let groups = try documents.compactMap({
                    try $0.data(as: Group.self)
                })
                self.myGroups = groups
                
                guard let index = groups.firstIndex(where: {$0.id == user.id}) else {
                    return
                }
                self.myGroup = groups[index]
                
                // Move my group to front at first
                self.myGroups.remove(at: index)
                self.myGroups.insert(self.myGroup!, at: 0)
                self.isAlreadyHaveGroup = true
            } catch {
                print(error.localizedDescription)
            }
            
        }
    }
}
