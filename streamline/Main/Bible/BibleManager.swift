//
//  BibleManager.swift
//  streamline
//
//  Created by Sibtain Ali (Fiverr) on 11/05/2023.
//

import SwiftUI
import SwiftyJSON

class BibleManager {
    
    static let shared = BibleManager()
    
    var books = [Book]()
    
    private init() {
        getBible()
    }
    
}

extension BibleManager {
    
    private func getBible() {
        
        guard let bibleData = Utils.shared.getJSONFile(name: "bible") else { return }
        let json = JSON(bibleData)
        
        do {
            let booksData = try json["BIBLEBOOK"].rawData()
            self.books = try JSONDecoder().decode([Book].self, from: booksData)
        }
        catch let error {
            printOnDebug("bible error: \(error.localizedDescription)")
        }
        
    }
}

