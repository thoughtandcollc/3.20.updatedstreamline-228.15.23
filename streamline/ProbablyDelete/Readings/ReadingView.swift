//
//  ReadingView.swift
//  streamline
//
//  Created by Matt Forgacs on 6/1/21.
//

import SwiftUI

struct ReadingView: View {
    @State var isShowingNewPostView = false
    @ObservedObject var viewModel = ReadingViewModel()
//    @State var clickedOut: Bool = false

    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView {
                VStack {
                    ForEach(viewModel.readings) { reading in
                        NavigationLink(destination: ReadingDetailView(reading: reading))
                            { ReadingCell(reading: reading)
                        }
                    }
                    } .padding()
                }
            
            Button(action: { isShowingNewPostView.toggle() }, label: {
                Image("folder")
                    .resizable()
                    .renderingMode(/*@START_MENU_TOKEN@*/.template/*@END_MENU_TOKEN@*/)
                    .frame(width: 32, height: 32)
                    .padding()
                
            }) .background(Color(.systemOrange))
            .foregroundColor(.white)
            .clipShape(Circle())
            .padding()
            .fullScreenCover(isPresented: $isShowingNewPostView) {
                NewReading(isPresented: $isShowingNewPostView)
            }
        }
    }
}
