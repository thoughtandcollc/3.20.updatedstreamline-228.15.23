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
    
    @State var verseIndex: Int
    
    var isFromPostView = false // for checking if user want to add this verse in post
    
    @Binding var bibleVerse: String // selected verse for post view
    @Binding var isDismiss: Bool // for dismissing from post view
    @State var verseCount = 0

    @State private var showingActionSheet = false
    
    var body: some View {
        VStack {}
        
//        VStack {
//
//            VerseTitleView()
//
//            VerseInfoView()
//
//            AddVerseView()
//
//            Spacer()
//
//            VerseButtonsView()
//
//        }
//        .padding()
//        .onAppear { onAppearHandling() }
//        .navigationBarTitle("Verse: \(verseIndex + 1)", displayMode: .inline)
        
    }
    
}

// MARK: - View Functions
// MARK: -
extension VerseDetailView {
    
    private func AddVerseView() -> some View {
        
        Button {
            showingActionSheet.toggle()
        } label: {
            Text("Add this verse")
        }
        .padding(.top, 50)
        .isVisible(isFromPostView)
        .actionSheet(isPresented: $showingActionSheet) {
            ActionSheet(title: Text("Add Verse To Post"), message: Text("Do you want to add the whole verse or just the reference"), buttons: [
                .default(Text("Whole Verse"),action: {
                    bibleVerse = (book.chapters[chapIndex].vers[verseIndex].text ?? "") + ";\(book.name), " + "Chapter: \(chapIndex + 1) " + "Verse: \(verseIndex + 1)"
                    isDismiss = false // dismiss this screen
                }),
                .default(Text("Just Reference"), action: {
                    bibleVerse = ";\(book.name), " + "Chapter: \(chapIndex + 1) " + "Verse: \(verseIndex + 1)"
                    isDismiss = false // dismiss this screen
                }),
                .cancel()
            ])
        }
        
    }
    

    
}

// MARK: - Helper Functions
// MARK: -
extension VerseDetailView {
    
    private func onAppearHandling() {
        
        verseCount = book.chapters[chapIndex].vers.count
        
    }
    
}

//struct VerseDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        VerseDetailView(book: B, chapIndex: <#Int#>, verseIndex: <#Int#>)
//    }
//}
