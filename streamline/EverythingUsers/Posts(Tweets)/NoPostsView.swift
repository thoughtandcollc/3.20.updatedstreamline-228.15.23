//
//  NoPostsView.swift
//  streamline
//
//  Created by Sibtain Ali on 01-08-2023.
//

import SwiftUI

struct NoPostsView: View {
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            HStack(alignment: .top, spacing: 12) {
                
                //-------------------------------------------------- Image
                
                Image("OnTheMargin")
                    .resizable()
                    .scaledToFill()
                    .clipped()
                    .cornerRadius(.infinity)
                    .defaultShadow()
                    .frame(width: 56, height: 56)
                
                
                VStack(alignment: .leading, spacing: 4) {
                    
                    //-------------------------------------------------- Title
                    
                    Text("OnTheMargin Team")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Color("AdaptiveColor"))
                    
                    
                    //-------------------------------------------------- Description
                    
                    Text("Welcome to OnTheMargin:\n\nAn app for you to connect more with the Bible, your church, and your community in one platform.\n\nFaith is for more than just Sunday. Join your group now!")
                        .fixedSize(horizontal: false, vertical: false)
                        .padding()
                    
                    
                    
                    Divider()
                }
                
            }
            
            
        }
        .padding()
        
    }

}

// MARK: - View Functions
// MARK: -
extension NoPostsView {
    
    
}
