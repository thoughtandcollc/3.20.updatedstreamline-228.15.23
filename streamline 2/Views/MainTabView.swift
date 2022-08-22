//
//  MainTabView.swift
//  streamline
//
//  Created by Matt Forgacs on 6/28/21.
//

import SwiftUI

struct MainTabView: View {
    @Binding var selectedIndex: Int
    @ObservedObject var viewModel: FeedViewModel
    
    var body: some View {
        TabView(selection: $selectedIndex) {
            FeedView(viewModel: viewModel)
                .onTapGesture {
                    selectedIndex = 0
                }
                .tabItem {
                    Image(systemName: "house")
                }.tag(0)
            
            ReadingView()
                .onTapGesture {
                    selectedIndex = 1
                }
                .tabItem {
                    Image(systemName: "bookmark")
                }.tag(1)
            
            AnnotateView()
                .onTapGesture {
                    selectedIndex = 2
                }
                .tabItem {
                    Image(systemName: "bolt")
                }.tag(2)
            
            ConversationsView()
                .onTapGesture {
                    selectedIndex = 3
                }
                .tabItem {
                    Image(systemName: "envelope")
                }.tag(3)
            
            ChapterSelection()
                .onTapGesture {
                    selectedIndex = 4
                }
                .tabItem {
                    Image(systemName: "book")
                }.tag(4)
        }
    }
}

