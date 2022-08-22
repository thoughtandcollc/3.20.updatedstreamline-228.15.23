//
//  ProfileHeaderView.swift
//  streamline
//
//  Created by Matt Forgacs on 5/25/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct ProfileHeaderView: View {
    @State var selectedFilter: PostFilterOptions = .posts
    @ObservedObject var viewModel: ProfileViewModel
    @State var showImagePicker = false
    @State var selectedUIImage: UIImage?
    @State var image: Image?
    
    
    func loadImage() {
        guard let selectedImage = selectedUIImage else { return }
        image = Image(uiImage: selectedImage)
    }
    
    var body: some View {
    VStack {
        Button(action: { showImagePicker.toggle() }, label: {
            ZStack {
                if let image = image {
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 140, height: 140)
                        .clipped()
                        .cornerRadius(70)
                        .padding(.top, 68)
                        .padding(.bottom, 2)
                } else {
                AnimatedImage(url: URL(string: viewModel.user.profileImageUrl))
                    .indicator(SDWebImageActivityIndicator.grayLarge)
                    .resizable()
                    .scaledToFill()
                    .clipped()
                    .frame(width: 120, height: 120)
                    .cornerRadius(120 / 2)
                    .shadow(color: /*@START_MENU_TOKEN@*/.black/*@END_MENU_TOKEN@*/, radius: 6, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/)
                }
            }
            }) .sheet(isPresented: $showImagePicker, onDismiss: loadImage, content: {
                ImagePicker {(image, imageURL) in
                    selectedUIImage = image
                }
            })

            
            
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
