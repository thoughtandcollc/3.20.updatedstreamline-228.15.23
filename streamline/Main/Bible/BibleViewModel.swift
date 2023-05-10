//
//  BibleViewModel.swift
//  streamline
//
//  Created by Sibtain Ali (Fiverr) on 05/05/2023.
//

import SwiftUI

class BibleViewModel: ObservableObject {
    
    var books = [Book]()
    
    // initialization
    init() {
        getBible()
    }
    
}


// MARK: - Api Functions
// MARK: -
extension BibleViewModel {
    
}


// MARK: - Getter Functions
// MARK: -
extension BibleViewModel {
    
    private func getBible() {
        guard let bibleData = Utils.shared.getJSONFile(name: "bible") else { return }
        do {
            books = try JSONDecoder().decode([Book].self, from: bibleData)
            
        }
        catch let error {
            printOnDebug("bible error: \(error.localizedDescription)")
        }
        
    }

    
}


// MARK: - Helper Functions
// MARK: -
extension BibleViewModel {
    
}

