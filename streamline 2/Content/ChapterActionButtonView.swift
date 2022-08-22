//
//  ChapterActionView.swift
//  streamline
//
//  Created by Matt Forgacs on 9/26/21.
//

//import SwiftUI
//
//struct ChapterActionButtonView: View {
//    @ObservedObject var viewModel: ChapterProfileViewModel
//    @State private var showSettings = false
//        
//    var body: some View {
//        if viewModel.user.isCurrentUser {
//            Button(action: {
//            }, label: {
//                Text("Your Profile")
//                    .frame(width: 360, height: 40)
//                    .background(Color.orange)
//                    .foregroundColor(.white)
//            })
//            .cornerRadius(20)
//        } else {
//                HStack {
//                    Button(action: {
//                        viewModel.user.isFollowed ? viewModel.unfollow() : viewModel.follow()
//                    }, label: {
//                        Text(viewModel.user.isFollowed ? "Following" : "Follow")
//                            .frame(width: 180, height: 40)
//                            .background(Color.orange)
//                            .foregroundColor(.white)
//                    })
//                    .cornerRadius(20)
//                    
//                    NavigationLink(destination: ChatView(user: viewModel.user), label: {
//                            Text("Message")
//                                    .frame(width: 180, height: 40)
//                                    .background(Color.gray)
//                                    .foregroundColor(.white)
//                            })
//                    .cornerRadius(20)
//                }
//            }
//        }
//    }
