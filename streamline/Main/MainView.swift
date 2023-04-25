//
//  MainView.swift
//  streamline
//
//  Created by Sibtain Ali (Fiverr) on 20/04/2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct MainView: View {
    
    @EnvironmentObject var viewModel  : AuthViewModel
    @ObservedObject var feedViewModel : FeedViewModel
    
    @State private var selectedIndex = 0
    @State private var showingMenu   = false
    
    var body: some View {
        
        NavigationView {
            
            ZStack {
                
                SideMenuView(isShowing: $showingMenu)
                    .padding(.top, 44)
                    .ignoresSafeArea()
                    .isVisible(showingMenu)
                
                
                MainTabView(viewModel: feedViewModel, selectedIndex: $selectedIndex)
                    .cornerRadius(showingMenu ? 20 : 10)
                    .ignoresSafeArea()
                    .navigationBarTitle(viewModel.tabTitle(forIndex: selectedIndex))
                    .navigationBarTitleDisplayMode(.inline)
                    .offset(x: showingMenu ? 300 : 0, y: showingMenu ? 44 : 0)
                    .opacity(showingMenu ? 0.25 : 1)
                    .scaleEffect(showingMenu ? 0.9 : 1)
                    .shadow(color: self.showingMenu ? .black : .clear, radius: 20, x: 0, y: 0)
                    .disabled(showingMenu)
                    .navigationBarItems(leading: ProfileImageButton(),
                                        trailing: selectedIndex == 0 ? RefreshButton() : nil)
                
            }
            .onAppear { self.showingMenu = false }
        }
        .navigationViewStyle(.stack)
    }
    
}

// MARK: - Helper View Functions
// MARK: -
extension MainView {
    
    private func ProfileImageButton() -> some View {
        Button(action: {
            withAnimation(.spring()) {
                self.showingMenu.toggle()
            }
        }, label: {
            if let user = viewModel.user {
                AnimatedImage(url: URL(string: user.profileImageUrl))
                    .indicator(SDWebImageActivityIndicator.grayLarge)
                    .resizable()
                    .scaledToFill()
                    .clipped()
                    .frame(width: 32, height: 32)
                    .cornerRadius(16)
            }
        })
    }
    
    private func RefreshButton() -> some View {
        Link(destination: URL(string: "https://www.youtube.com/channel/UCqWw9LaEalLrfrHlrBAP8fA/playlists")!) {
            Image(systemName: "questionmark.circle")
                .foregroundColor(Color("AdaptiveColor"))
                
                
        }

    }

    
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(feedViewModel: FeedViewModel())
    }
}
