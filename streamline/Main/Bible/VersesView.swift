//
//  VersesView.swift
//  streamline
//
//  Created by Sibtain Ali (Fiverr) on 05/05/2023.
//

import SwiftUI

struct VersesView: View {
    
    @Environment(\.colorScheme) var colorScheme
        
    var book: Book
    var chapIndex: Int
    
    var isFromPostView = false // for checking if user want to add this verse in post
    @Binding var bibleVerse: String // selected verse for post view
    @Binding var isDismiss: Bool // for dismissing from post view
    
    var body: some View {
        
        ScrollView {
            LazyVStack {
                ForEach(book.chapters[chapIndex].vers, id: \.self.verseNumber) { verse in
                    VStack{
                        VerseTitleView(verse: verse)
                        VerseInfoView(verse: verse)
                    }
                }
            }
            .padding()
        }
        .navigationBarTitle("Chapter: \(chapIndex + 1)")
        
    }
    
    init(book: Book, selectedChapIndex: Int, isFromPostView: Bool, bibleVerse: Binding<String>, isDismiss: Binding<Bool>) {
        self.book = book
        self.chapIndex = selectedChapIndex
        self.isFromPostView = isFromPostView
        _bibleVerse = bibleVerse
        _isDismiss = isDismiss
    }
    
}

// MARK: - View Functions
// MARK: -
extension VersesView {
    
    private func VerseTitleView(verse: Ver) -> some View {
        
        Text(verse.text ?? "")
            .font(.title3)
            .padding()
            .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
            .background(RoundedRectangle(cornerRadius: 12)
                .foregroundColor(colorScheme == .dark ? .black : .white)
                .defaultShadow()
            )
        
    }
    
    private func VerseInfoView(verse: Ver) -> some View {
        
        SwiftUI.Group {
            Text("\(book.name),")
            Text("Chapter: \(chapIndex + 1)")
            Text("Verse: \(verse.verseNumber ?? "")")
        }
        .font(.system(size: 13))
        .trailing()
        
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
