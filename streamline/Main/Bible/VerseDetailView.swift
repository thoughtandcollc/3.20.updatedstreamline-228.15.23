//
//  VerseDetailView.swift
//  streamline
//
//  Created by Sibtain Ali (Fiverr) on 09/05/2023.
//

import SwiftUI

struct VerseDetailView: View {
    
    @Environment(\.colorScheme) var colorScheme
    var book: Book
    var chapIndex: Int
    var verseIndex: Int
    
    var body: some View {
        
        VStack {
            
            Text(book.chapters[chapIndex][verseIndex])
                .font(.title2)
                .padding()
                .background(RoundedRectangle(cornerRadius: 12)
                    .foregroundColor(colorScheme == .dark ? .black : .white)
                    .defaultShadow()
                )
            
            SwiftUI.Group {
                Text("\(book.name),")
                Text("Chapter: \(chapIndex + 1)")
                Text("Verse: \(verseIndex + 1)")
            }
            .font(.system(size: 13))
            .trailing()
            
            Spacer()
            
        }
        .padding()
        .navigationBarTitle("Verse: \(verseIndex + 1)")
        
    }
}

//struct VerseDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        VerseDetailView(book: B, chapIndex: <#Int#>, verseIndex: <#Int#>)
//    }
//}
