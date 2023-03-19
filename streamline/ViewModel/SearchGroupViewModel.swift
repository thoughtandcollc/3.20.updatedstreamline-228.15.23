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
    
}


// MARK: - Getter Functions
// MARK: -
extension SearchGroupViewModel {
    
}


// MARK: - Helper Functions
// MARK: -
extension SearchGroupViewModel {
    
}

