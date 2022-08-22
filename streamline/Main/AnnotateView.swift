//
//  AnnotateView.swift
//  streamline
//
//  Created by Matt Forgacs on 9/13/21.
//

import SwiftUI
import Firebase

struct AnnotateView: View {
    @State var isShowingNewNoteView = false
    @ObservedObject var viewModel = AnnotationsViewModel()
    
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView {
                VStack {
                    ForEach(viewModel.annotate) { annotate in
                        AnnotateCell(annotate: annotate)
//                        NavigationLink(destination: AnnotationsDetailView(annotations: annotate))
//                        { AnnotateCell(annotate: annotate)
//                        }
//                    }
                    } .padding()
                }
            

        }
            Button(action: { isShowingNewNoteView.toggle() }, label: {
                Image(systemName: "bolt")
                    .resizable()
                    .renderingMode(/*@START_MENU_TOKEN@*/.template/*@END_MENU_TOKEN@*/)
                    .frame(width: 32, height: 32)
                    .padding()
                
            }) .background(Color(.systemOrange))
            .foregroundColor(.white)
            .clipShape(Circle())
            .padding()
            .fullScreenCover(isPresented: $isShowingNewNoteView) {
                NewNote(isPresented: $isShowingNewNoteView)
            }
    }
}
}
