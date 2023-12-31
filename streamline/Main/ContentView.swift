//
//  ContentView.swift
//  streamline
//
//  Created by Matt Forgacs on 5/23/21.
//

import SwiftUI
import SDWebImageSwiftUI
import MapKit

struct ContentView: View {
    
    @EnvironmentObject var viewModel : AuthViewModel
    @StateObject var feedModel  = FeedViewModel()

    var body: some View {
        
        VStack {
            
            // user is logged in
            if viewModel.userSession != nil {
                MainView(feedModel: feedModel)
                
                // user is logged out
            } else {
                LoginView()
                    .onAppear { feedModel.selectedGroupId = ""}
            }
            
        }
    }

}


// MARK: - Preview
// MARK: -
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
