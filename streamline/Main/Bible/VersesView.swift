//
//  VersesView.swift
//  streamline
//
//  Created by Sibtain Ali (Fiverr) on 05/05/2023.
//

import SwiftUI

struct VersesView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @Binding var bibleVerse : String // selected verse for post view
    @Binding var isDismiss  : Bool   // for dismissing from post view
    
    var isFromPostView = false // for checking if user want to add this verse in post
    
    var book      : Book // book
    var chapIndex : Int  // index of the selected chapter
    
    @State var selectedVerseList = Set<String>() // verses selected by the user
    
    var body: some View {
        
        ScrollView {
            
            VerseListView()
            
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
    
    private func VerseListView() -> some View {
        
        LazyVStack {
            ForEach(book.chapters[chapIndex].vers, id: \.self.verseNumber) { verse in
                VerseMainView(verse: verse)
            }
        }
        .padding()
        
    }
    
    private func VerseMainView(verse: Ver) -> some View {
        
        VStack {
            VerseTitleView(verse: verse)
            VerseInfoView(verse: verse)
        }
        .contentShape(Rectangle())
        .onTapGesture { verseTapped(verse: verse) }
        
    }
    
    private func VerseTitleView(verse: Ver) -> some View {
        
        HStack {
            
            SelectionButtonView(verse: verse)
            
            Text(verse.text ?? "")
                .font(.title3)
                .padding()
                .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                .background(RoundedRectangle(cornerRadius: 12)
                    .foregroundColor(colorScheme == .dark ? .black : .white)
                    .defaultShadow()
                )
        }
        
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
    
    private func SelectionButtonView(verse: Ver) -> some View {
        
        Image(systemName: selectedVerseList.contains(verse.verseNumber ?? "") ? "checkmark.circle.fill" : "circle")
            .padding(.trailing)
            .isVisible(isFromPostView)

    }
    
}

// MARK: - Helper Functions
// MARK: -
extension VersesView {
    
    private func verseTapped(verse: Ver) {
        
        // only allow tap if user is from post view
        guard isFromPostView else { return }
        
        guard let verseNumber = verse.verseNumber else { return }
        
        if selectedVerseList.contains(verseNumber) {
            selectedVerseList.remove(verseNumber)
        }
        else {
            selectedVerseList.insert(verseNumber)
        }

        
    }

}
