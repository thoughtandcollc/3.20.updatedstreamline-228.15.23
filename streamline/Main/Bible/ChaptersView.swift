//
//  ChaptersView.swift
//  streamline
//
//  Created by Sibtain Ali (Fiverr) on 05/05/2023.
//

import SwiftUI

struct ChaptersView: View {
    
    @State private var searchText = ""
    @State private var isSearching = false
    
    var book: Book
    var chapters: [String] = []
    
    var isFromPostView = false // for checking if user want to add this verse in post
    @Binding var bibleVerse: String // selected verse for post view
    @Binding var isDismiss: Bool // for dismissing from post view
    
    var body: some View {
        
        VStack {
            
            SearchBarView(searchText: $searchText, isSearching: $isSearching)
                .padding(.top, 10)
                .padding(.horizontal, 20)
            
            List {
                ForEach(chapters.filter { searchText.isEmpty ? true : $0.localizedCaseInsensitiveContains(searchText) }, id: \.self) { chapter in
                    NavigationLink(destination: VersesView(book: book, selectedChapIndex: getIndex(chapter), isFromPostView: isFromPostView, bibleVerse: $bibleVerse, isDismiss: $isDismiss)) {
                        Text(chapter)
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .padding(.top, 10)
        }
        .navigationBarTitle(book.name)
        
    }
    
    init(book: Book, isFromPostView: Bool, bibleVerse: Binding<String>, isDismiss: Binding<Bool>) {
        self.book = book
        self.isFromPostView = isFromPostView
        _bibleVerse = bibleVerse
        _isDismiss = isDismiss
        
        for index in 0..<book.chapters.count {
            chapters.append("Chapter: \(index + 1)")
        }
    }
    
}

// MARK: - Helper Functions
// MARK: -
extension ChaptersView {
    
    private func getIndex(_ string: String) -> Int {
        let str = string.components(separatedBy: " ").last
        return (Int(str ?? "1") ?? 1) - 1
    }

}


//struct ChaptersView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChaptersView(, book: nil)
//    }
//}
