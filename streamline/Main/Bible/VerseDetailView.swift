//
//  VerseDetailView.swift
//  streamline
//
//  Created by Sibtain Ali (Fiverr) on 09/05/2023.
//

import SwiftUI

struct VerseDetailView: View {
    
    @Environment(\.presentationMode) var presentationMode // for dismissing this view
    @Environment(\.colorScheme) var colorScheme
    var book: Book
    var chapIndex: Int
    var verseIndex: Int
    
    var isFromPostView = false // for checking if user want to add this verse in post
    
    @Binding var bibleVerse: String // selected verse for post view
    @Binding var isDismiss: Bool // for dismissing from post view
    
    var body: some View {
        
        VStack {
            
            VerseTitleView()
            
            VerseInfoView()
            
            AddVerseView()

            Spacer()
            
            VerseButtonsView()
            
            
        }
        .padding()
        .navigationBarTitle("Verse: \(verseIndex + 1)", displayMode: .inline)
        
    }
    
}

// MARK: - View Functions
// MARK: -
extension VerseDetailView {
    
    private func VerseTitleView() -> some View {
        
        Text(book.chapters[chapIndex].vers[verseIndex].text ?? "")
            .font(.title2)
            .padding()
            .background(RoundedRectangle(cornerRadius: 12)
                .foregroundColor(colorScheme == .dark ? .black : .white)
                .defaultShadow()
            )
        
    }
    
    private func VerseInfoView() -> some View {
        
        SwiftUI.Group {
            Text("\(book.name),")
            Text("Chapter: \(chapIndex + 1)")
            Text("Verse: \(verseIndex + 1)")
        }
        .font(.system(size: 13))
        .trailing()
        
    }
    
    private func AddVerseView() -> some View {
        
        Button {
            bibleVerse = (book.chapters[chapIndex].vers[verseIndex].text ?? "") + ";\(book.name), " + "Chapter: \(chapIndex + 1) " + "Verse: \(verseIndex + 1)"
            isDismiss = false
        } label: {
            Text("Add this verse")
        }
        .padding(.top, 50)
        .isVisible(isFromPostView)
        
    }
    
    private func VerseButtonsView() -> some View {
        
        HStack {}
        
    }
    
}

//struct VerseDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        VerseDetailView(book: B, chapIndex: <#Int#>, verseIndex: <#Int#>)
//    }
//}