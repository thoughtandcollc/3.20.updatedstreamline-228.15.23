//
//  Bible.swift
//  streamline
//
//  Created by Sibtain Ali (Fiverr) on 05/05/2023.
//

import SwiftUI

//class Book: Codable {
//
//    var abbrev: String
//    var chapters: [[String]]
//    var name: String
////    var index: Int
//
////    class Chapter: Codable {
////        var index: Int
////        var verses: [String]
////    }
//
//}

//struct Bible: Codable {
//
//    let books: [Book]
//    let bibleName: String
//
//    enum CodingKeys: String, CodingKey {
//        case books = "BIBLEBOOK"
//        case bibleName = "_biblename"
//    }
//
//}

// MARK: - Bible book
struct Book: Codable {
    let chapters: [BookChapter]
    let bookNumber, name: String

    enum CodingKeys: String, CodingKey {
        case chapters = "CHAPTER"
        case bookNumber = "_bnumber"
        case name = "_bname"
    }
}

// MARK: - Chapter
struct BookChapter: Codable {
    let vers: [Ver]
    let chapterNumber: String

    enum CodingKeys: String, CodingKey {
        case vers = "VERS"
        case chapterNumber = "_cnumber"
    }
}

// MARK: - Ver
struct Ver: Codable {
    let verseNumber, text: String?

    enum CodingKeys: String, CodingKey {
        case verseNumber = "_vnumber"
        case text = "__text"
    }
}






