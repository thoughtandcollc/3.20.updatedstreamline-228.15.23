//
//  VersesView.swift
//  streamline
//
//  Created by Sibtain Ali (Fiverr) on 05/05/2023.
//

import SwiftUI

struct VersesView: View {
    
    @State private var searchText = ""
    @State private var isSearching = false
    
    var book: Book
    var chapIndex: Int
    var verses: [String] = []
    
    var isFromPostView = false // for checking if user want to add this verse in post
    @Binding var bibleVerse: String // selected verse for post view
    @Binding var isDismiss: Bool // for dismissing from post view
    
    var body: some View {
        
        VStack {
            
            SearchBarView(searchText: $searchText, isSearching: $isSearching)
                .padding(.top, 10)
                .padding(.horizontal, 20)
            
            List {
                ForEach(verses.filter { searchText.isEmpty ? true : $0.localizedCaseInsensitiveContains(searchText) }, id: \.self) { verse in
                    NavigationLink(destination: VerseDetailView(book: book, chapIndex: chapIndex, verseIndex: getIndex(verse), isFromPostView: isFromPostView, bibleVerse: $bibleVerse, isDismiss: $isDismiss)) {
                        Text(verse)
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .padding(.top, 10)
        }
        .navigationBarTitle("Chapter: \(chapIndex + 1)")
        
    }
    
    init(book: Book, selectedChapIndex: Int, isFromPostView: Bool, bibleVerse: Binding<String>, isDismiss: Binding<Bool>) {
        self.book = book
        self.chapIndex = selectedChapIndex
        self.isFromPostView = isFromPostView
        _bibleVerse = bibleVerse
        _isDismiss = isDismiss
        
        for index in 0..<book.chapters[selectedChapIndex].vers.count {
            verses.append("Verse: \(index + 1)")
        }
    }
    
}

// MARK: - Helper Functions
// MARK: -
extension VersesView {
    
    private func getIndex(_ string: String) -> Int {
        let str = string.components(separatedBy: " ").last
        return (Int(str ?? "1") ?? 1) - 1
    }

    
}
