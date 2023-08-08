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


// MARK: - Api Functions
// MARK: -
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


// MARK: - Getter Functions
// MARK: -
extension BibleManager {
    
    func getVerseInfo(post: Post) -> String {
        
        if post.caption.contains(VERSE_DIVIDER) {
            return post.caption.components(separatedBy: VERSE_DIVIDER).last ?? ""
        }
        else {
            // for older posts
            let caption = post.caption.components(separatedBy: ";").first ?? ""
            let verseInfo = post.caption.components(separatedBy: ";").last ?? ""
            if verseInfo.contains("Verse"), verseInfo.contains("Chapter") {
                return verseInfo
            }
            else {
                return ""
            }
        }
        // uncomment this one later
//        else {
//            return ""
//        }
        
    }
    
    func getCaptionForPost(post: Post) -> String {
        
        if post.caption.contains(VERSE_DIVIDER) {
            return post.caption.components(separatedBy: VERSE_DIVIDER).first ?? ""
        }
        else {
            // for older posts
            let caption = post.caption.components(separatedBy: ";").first ?? ""
            let verseInfo = post.caption.components(separatedBy: ";").last ?? ""
            if verseInfo.contains("Verse"), verseInfo.contains("Chapter") {
                return caption
            }
            else {
                return post.caption
            }
        }
        // uncomment this one later
//        else {
//            return post.caption
//        }
    }

    func getBook(verseInfo: String) -> Book {
        let bookName = verseInfo.components(separatedBy: ",").first ?? ""
        let book = BibleManager.shared.books.first(where: {$0.name == bookName}) ?? BibleManager.shared.books.first!
        return book
    }
    
    func getChapter(verseInfo: String) -> Int {
        var chapNum = verseInfo.components(separatedBy: "Chapter: ").last ?? ""
        chapNum = chapNum.components(separatedBy: " ").first ?? ""
        var chapIndex = Int(chapNum) ?? 0
        if chapIndex != 0 { chapIndex -= 1 }
        return chapIndex
    }
    
    func getVerses(verseInfo: String) -> [String] {
        var text = String(verseInfo.components(separatedBy: "Verse: ").last ?? "")
        var result = [String]()
        
        if text.contains("-") {
            text = text.replacingOccurrences(of: " ", with: "")
            let components = text.components(separatedBy: "-")
            guard components.count == 2, let start = Int(components[0]), let end = Int(components[1]) else {
                return []
            }
            result = (start...end).map { String($0) }
        }
        else {
            result = text.components(separatedBy: ",")
        }
        
        return result
    }
    
}


