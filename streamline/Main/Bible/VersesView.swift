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
    
    var book         : Book // book
    var chapIndex    : Int  // index of the selected chapter
    var versesToShow : [String]  // if verse reference from post is tapped
    
    @State var selectedVerseList = Set<String>() // verses selected by the user
    
    @State private var showingActionSheet = false // show alert for adding only reference or whole verse
    
    var body: some View {
        
        ScrollView {
            
            VerseListView()
            
        }
        .toolbar { TopRightButtonView() }
        .navigationBarTitle("Chapter: \(chapIndex + 1)")
        
    }
    
    init(book: Book, selectedChapIndex: Int, versesToShow: [String] = [], isFromPostView: Bool, bibleVerse: Binding<String>, isDismiss: Binding<Bool>) {
        self.book = book
        self.chapIndex = selectedChapIndex
        self.isFromPostView = isFromPostView
        self.versesToShow = versesToShow
        _bibleVerse = bibleVerse
        _isDismiss = isDismiss
    }
    
}

// MARK: - View Functions
// MARK: -
extension VersesView {
    
    private func VerseListView() -> some View {
        
        LazyVStack {
            ForEach(getVerses(), id: \.self.verseNumber) { verse in
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

// MARK: - Helper View Functions
// MARK: -
extension VersesView {
    
    private func TopRightButtonView() -> some ToolbarContent {
        
        // button on top right
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                showingActionSheet.toggle()
            } label: {
                Text("Add Verse(s)")
            }
            .isVisible(isFromPostView && selectedVerseList.count > 0)
            .actionSheet(isPresented: $showingActionSheet) {
                ActionSheet(title: Text("Add Verse To Post"), message: Text("Do you want to add the whole verse(s) or just the reference"), buttons: [
                    .default(Text("Whole Verse"),action: {
                        addVerses(addTextAlso: true)
                    }),
                    .default(Text("Just Reference"), action: {
                        addVerses(addTextAlso: false)
                    }),
                    .cancel()
                ])
            }
        }
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
    
    private func addVerses(addTextAlso: Bool) {

        
        // for single selected verse
        if selectedVerseList.count == 1 {
            addSingleVerse(addTextAlso: addTextAlso)
            return
        }
        
        // for multiple verses
        addMultipleVerses(addTextAlso: addTextAlso)
        
    }
    
    private func addSingleVerse(addTextAlso: Bool) {
        
        bibleVerse = "\(VERSE_DIVIDER)\(book.name), " + "Chapter: \(chapIndex + 1) " + "Verse: \(selectedVerseList.first ?? "")"
        
        if addTextAlso {
            let verseIndex = (Int(selectedVerseList.first ?? "") ?? -1) - 1
            let text = book.chapters[chapIndex].vers[safe: verseIndex]?.text ?? ""
            bibleVerse = text + bibleVerse
        }
        
        isDismiss = false // dismiss this screen
        
    }
    
    private func addMultipleVerses(addTextAlso: Bool) {
                
        let versesIndexes = Array(selectedVerseList).sorted()
        var versesText = ""
        
        // verse: 1-5
        if hasConsecutiveNumbers(versesIndexes) {
            versesText = "\(versesIndexes.first ?? "") - \(versesIndexes.last ?? "")"
        }
        // verse: 1,4,7,9
        else {
            versesText = versesIndexes.joined(separator: ",")
        }
        
        bibleVerse = "\(VERSE_DIVIDER)\(book.name), " + "Chapter: \(chapIndex + 1) " + "Verse: \(versesText)"
        
        // if user also wants verses text
        if addTextAlso {
            for index in Array(versesIndexes.reversed()) {
                let verseIndex = (Int(index) ?? -1) - 1
                let text = book.chapters[chapIndex].vers[safe: verseIndex]?.text ?? ""
                bibleVerse = text + "\n\n" + bibleVerse
            }
        }
        
        isDismiss = false // dismiss this screen
        
    }

    private func hasConsecutiveNumbers(_ arr: [String]) -> Bool {
        let sortedArr = arr.compactMap { Int($0) }
        for i in 0..<sortedArr.count-1 {
            if sortedArr[i+1] - sortedArr[i] != 1 {
                return false
            }
        }
        return true
    }
    
    private func getVerses() -> [Ver] {
        
        // show all verses
        if versesToShow.isEmpty {
            return book.chapters[chapIndex].vers
        }
        
        // show specific verses
        var verses = [Ver]()
        for index in versesToShow {
            if let ind = Int(index), let ver = book.chapters[chapIndex].vers[safe: ind - 1 ]  {
                verses.append(ver)
            }
        }
        return verses
        
    }


}
