//
//  MainTabView.swift
//  streamline
//
//  Created by Matt Forgacs on 6/28/21.
//

import SwiftUI

struct MainTabView: View {
    
    @ObservedObject var getGroupModel = GetGroupViewModel()
    @ObservedObject var feedModel: FeedViewModel
    
    @Binding var selectedIndex: Int
    
    var body: some View {
        
        TabView(selection: $selectedIndex) {
            FeedView(viewModel: feedModel, myGroupViewModel: getGroupModel)
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
        .toolbar { ToolbarItemsView() }
        
    }
    
    init(viewModel: FeedViewModel, selectedIndex: Binding<Int>) {
        self.feedModel = viewModel
        _selectedIndex = selectedIndex
        
        // Fix tabbar transparency
        let tabBarAppearance: UITabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithDefaultBackground()
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
    }

}

// MARK: - View Functions
// MARK: -
extension MainTabView {
    
    
    private func ToolbarItemsView() -> some ToolbarContent {
        
        ToolbarItemGroup(placement: .navigationBarTrailing) {
            
            Button {
                self.feedModel.showGroupSearchView.toggle()
            } label: {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(Color("AdaptiveColor"))
            }
            
            
            Button {
                
                // group limit check
                guard getGroupModel.myGroups.count < 5 else {
                    customAlertApple(title: "Maximum Limit Reached", message: "Each user can create maximum 5 groups", yesButtonTitle: "Okay")
                    return
                }
                
                // show create group screen
                self.feedModel.showingCreateGroup.toggle()
                
            } label: {
                Image(systemName: "plus")
                    .foregroundColor(Color("AdaptiveColor"))
            }
        }

    }
    
}

