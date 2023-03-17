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
    @ObservedObject var getGroupViewModel = GetGroupViewModel()

    var body: some View {
        TabView(selection: $selectedIndex) {
            FeedView(viewModel: viewModel, myGroupViewModel: getGroupViewModel)
                .onTapGesture {
                    selectedIndex = 0
                }
                .tabItem {
                    Image(systemName: "house")
                }.tag(0)
            
//            DailyView()
//                .onTapGesture {
//                    selectedIndex = 1
//                }
//                .tabItem {
//                    Image(systemName: "bolt")
//                }.tag(1)
            
            ConversationsView()
                .onTapGesture {
                    selectedIndex = 2
                }
                .tabItem {
                    Image(systemName: "envelope")
                }.tag(2)
            
//            ChapterSelection()
//                .onTapGesture {
//                    selectedIndex = 3
//                }
//                .tabItem {
//                    Image(systemName: "book")
//                }.tag(3)
            
            NotificationsView()
                .onTapGesture {
                    selectedIndex = 4
                }
                .tabItem {
                    Image(systemName: "bell.fill")
                }.tag(4)
            
//                CommentsConversationView()
//                .onTapGesture {
//                    selectedIndex = 4
//                }
//                .tabItem {
//                    Image(systemName: "bookmark")
//                }.tag(4)
        }
    }
}

