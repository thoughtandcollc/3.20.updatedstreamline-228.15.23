//
//  ChapterViewModel.swift
//  streamline
//
//  Created by Matt Forgacs on 9/24/21.
// SearchViewModel

import SwiftUI
import Firebase

class ChapterViewModel: ObservableObject {
    @Published var chapter = [Chapter]()

    init() {
        fetchChapter()

    }

    func fetchChapter() {
        COLLECTION_CHAPTERS.getDocuments { snapshot, _ in
            guard let documents = snapshot?.documents else { return }
            self.chapter = documents.map({ Chapter(dictionary: $0.data()) })
            self.chapter = self.chapter.sorted(by: { $0.timestamp.dateValue() < $1.timestamp.dateValue() })
        }
    }
}
