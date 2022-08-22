//
//  ReadingActionView.swift
//  streamline
//
//  Created by Matt Forgacs on 6/17/21.
//

import SwiftUI

struct ReadingActionView: View {
    let reading: Reading
    @State var isShowingReplyView = false
    @State var isShowingNewMarginView = false
    @ObservedObject var viewModel: ReadingActionViewModel
    
    init(reading: Reading) {
        self.reading = reading
        self.viewModel = ReadingActionViewModel(reading: reading)
    }
    
    var body: some View {
        HStack {
            Button(action: {
                    viewModel.didLike ? viewModel.unlikeReading() : viewModel.likeReading() }, label: {
                Image(systemName: viewModel.didLike ? "heart.fill" : "heart")
                    .font(.system(size: 16))
                    .frame(width: 32, height: 32)
                    .foregroundColor(viewModel.didLike ? .orange : .gray)
                        
                Text("\(reading.likes)")
                    .foregroundColor(.gray)
                        
    Spacer()
                                                        
            Button(action: {
                self.isShowingNewMarginView.toggle() },
            label: {
                Image(systemName: "pencil.circle")
                    .font(.system(size: 16))
                    .frame(width: 32, height: 32)
                    .foregroundColor(.gray)

            }) .padding().popover(isPresented: $isShowingNewMarginView, content: {
                NewMargin(isPresented: $isShowingNewMarginView)
            })
                        
//        Spacer()
//            Button(action: {
//                    self.isShowingReplyView.toggle() }, label: {
//                Image(systemName: "bubble.left")
//                    .font(.system(size: 16))
//                    .frame(width: 32, height: 32)
//                    .foregroundColor(.gray)
//                    }).padding(2.0).sheet(isPresented: $isShowingReplyView, content: {
//                NewPost(isPresented: $isShowingReplyView)
//
//            })
            
                    })

        }
        .padding(.horizontal)
    }
}
