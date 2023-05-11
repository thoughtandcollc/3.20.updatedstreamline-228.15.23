//
//  BibleViewModel.swift
//  streamline
//
//  Created by Sibtain Ali (Fiverr) on 05/05/2023.
//

import SwiftUI
import SwiftyJSON

class BibleViewModel: ObservableObject {
    
    @Published var books = [Book]()
    
    // initialization
    init() {
        books = BibleManager.shared.books
    }
    
}


// MARK: - Api Functions
// MARK: -
extension BibleViewModel {
    
}


// MARK: - Getter Functions
// MARK: -
extension BibleViewModel {
    
//    private func getBible() {
//        
//        guard let bibleData = Utils.shared.getJSONFile(name: "bible") else { return }
//        let json = JSON(bibleData)
//        
//        do {
//            let booksData = try json["BIBLEBOOK"].rawData()
//            books = try JSONDecoder().decode([Book].self, from: booksData)
//        }
//        catch let error {
//            printOnDebug("bible error: \(error.localizedDescription)")
//        }
//        
//    }

    
}


// MARK: - Helper Functions
// MARK: -
extension BibleViewModel {
    
}

