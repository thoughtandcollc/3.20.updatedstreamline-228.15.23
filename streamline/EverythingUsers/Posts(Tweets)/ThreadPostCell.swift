//
//  ThreadPostCell.swift
//  streamline
//
//  Created by Tayyab Ali on 07/03/2022.
//

import SwiftUI

//struct ThreadPostCell: View {
//    var post: Post
//    @State private var height: CGFloat = .zero
//
//    var body: some View {
//        
//        VStack(alignment: .leading) {
//            HStack(alignment: .top, spacing: 12) {
//                VStack(alignment: .leading, spacing: 4) {
//                    HStack {
//                        Text(post.fullname)
//                            .font(.system(size: 14, weight: .semibold))
//                            .foregroundColor(Color("AdaptiveColor"))
//                        
//                        //                        Text("@\(post.username) •")
//                        //                            .foregroundColor(.gray)
//                        
//                        Text(post.timestampString)
//                            .foregroundColor(.gray)
//                    }
//                    
//                    HStack {
////                        Text(post.caption)
////                            .multilineTextAlignment(.leading)
////                            .foregroundColor(Color("AdaptiveColor"))
////                            .padding()
//                        TextWithLinks(string: post.caption, fontSize: 14, dynamicHeight: $height) { url in
//                            openBrowserWith(url: url.absoluteString)
//                        }
//                        .frame(minHeight: height)
//                        .fixedSize(horizontal: false, vertical: true)
//                        .padding()
//                    }
//                    
//                    PostActionView(post: post)
//                    Divider()
//                }
//                
//            }
//            //            .padding(.bottom)
//            //            .padding(.trailing)
//            
//        }
//        .padding(.leading, 52) //post.multiPostId == previousPost?.multiPostId ? 16 :
//    }
//}
