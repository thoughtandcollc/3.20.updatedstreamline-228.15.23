//
//  BibleView.swift
//  streamline
//
//  Created by Sibtain Ali (Fiverr) on 05/05/2023.
//
import SwiftUI

struct BooksView: View {
    
    @StateObject var model = BibleViewModel()
    @State private var searchText = ""
    @State private var isSearching = false
    
    var isFromPostView = false // for checking if user want to add this verse in post
    @Binding var bibleVerse: String // selected verse for post view
    @Binding var isDismiss: Bool // for dismissing from post view
    
    var body: some View {
        
        VStack {
            
            SearchBarView(searchText: $searchText, isSearching: $isSearching)
                .padding(.top, 10)
                .padding(.horizontal, 20)
            
            List {
                
                ForEach(model.books.filter { searchText.isEmpty ? true : $0.name.localizedCaseInsensitiveContains(searchText) }, id: \.self.name) { book in
                    
                    NavigationLink(destination: ChaptersView(book: book, isFromPostView: isFromPostView, bibleVerse: $bibleVerse, isDismiss: $isDismiss)) {
                        Text(book.name)
                    }
                }
            }
            .padding(.top, 10)
        }
        
    }
}


struct BibleView_Previews: PreviewProvider {
    static var previews: some View {
        BooksView(bibleVerse: .constant(""), isDismiss: .constant(false))
    }
}
