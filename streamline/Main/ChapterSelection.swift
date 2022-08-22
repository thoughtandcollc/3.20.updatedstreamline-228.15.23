//
//  FullBook.swift
//  streamline
//
//  Created by Matt Forgacs on 9/24/21.
//

import SwiftUI
import Firebase

struct ChapterSelection: View {

    @State var isShowingNewChapterView = false
    @ObservedObject var viewModel = ChapterViewModel()
    
var body: some View {
    ZStack(alignment: .bottomTrailing) {
        ScrollView {
            VStack {
                ForEach(viewModel.chapter) { chapter in
                    NavigationLink(destination: ChapterView(chapter: chapter))
                    { ChapterCell(chapter: chapter)
                    }
                }
                } .padding()
            }
        
//        Button(action: { isShowingNewChapterView.toggle() }, label: {
//            Image("folder")
//                .resizable()
//                .renderingMode(/*@START_MENU_TOKEN@*/.template/*@END_MENU_TOKEN@*/)
//                .frame(width: 32, height: 32)
//                .padding()
//
//        }) .background(Color(.systemOrange))
//        .foregroundColor(.white)
//        .clipShape(Circle())
//        .padding()
//        .fullScreenCover(isPresented: $isShowingNewChapterView) {
//            NewChapter(isPresented: $isShowingNewChapterView)
//        }
    }
}


//struct FullBook_Previews: PreviewProvider {
//    static var previews: some View {
//        FullBook()
//    }
//}
}
