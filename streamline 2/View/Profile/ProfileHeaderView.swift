//
//  ProfileHeaderView.swift
//  streamline
//
//  Created by Matt Forgacs on 5/25/21.
//

import SwiftUI
import Kingfisher

struct ProfileHeaderView: View {
    @State var selectedFilter: PostFilterOptions = .posts
    @ObservedObject var viewModel: ProfileViewModel
    
    var body: some View {
        VStack {
            KFImage(URL(string: viewModel.user.profileImageUrl))
                .resizable()
                .scaledToFill()
                .clipped()
                .frame(width: 120, height: 120)
                .cornerRadius(120 / 2)
                .shadow(color: /*@START_MENU_TOKEN@*/.black/*@END_MENU_TOKEN@*/, radius: 6, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/)
            
            Text(viewModel.user.fullname)
                .font(.system(size: 16, weight: .semibold))
                .padding(.top, 8)
            
            Text(viewModel.user.email)
                .font(.subheadline)
                .foregroundColor(.gray)
            
     //       Text("Billionaire by Day, Hero by Knight")
       //         .font(.system(size: 14))
         //       .padding(.top, 8)
            
            HStack(spacing: 40) {
                VStack {
                    Text("\(viewModel.user.stats.followers)")
                        .font(.system(size: 16)).bold()
                    
                    Text("Followers")
                        .font(.footnote)
                        .foregroundColor(.gray)
                    
                }
                
                VStack {
                    Text("\(viewModel.user.stats.following)")
                        .font(.system(size: 16)).bold()
                    
                    Text("Following")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
                
                VStack {
                    NavigationLink(
                        destination: SettingsPage(),
                        label: {
                            Text("Settings")
                        })
                }
            }
            .padding()
            
            ProfileActionButtonView(viewModel: viewModel)
            

            
            Spacer()
        }
    }
}
