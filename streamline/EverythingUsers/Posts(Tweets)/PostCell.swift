//
//  TweetCell.swift
//  streamline
//
//  Created by Matt Forgacs on 5/23/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct PostCell: View {
    let posts: [Post]
    //    var previousPost: Post?
    var firstPost: Post {
        return posts.first!
    }
    @State var showMorePosts = false
    @State private var height: CGFloat = .zero
    @State var selectedPhotoURL: URL?
    @Namespace var namespace
    @State private var showVerseView = false // show verse view
    
    var profileView: some View {
        AnimatedImage(url: URL(string: firstPost.profileImageUrl))
            .indicator(SDWebImageActivityIndicator.grayLarge)
            .resizable()
            .scaledToFill()
            .clipped()
            .cornerRadius(.infinity)
            .defaultShadow()
    }
    
    var body: some View {
        
        if selectedPhotoURL != nil {
            Color
                .black
                .ignoresSafeArea()
                .overlay {
                    AnimatedImage(url: selectedPhotoURL)
                        .resizable()
                        .indicator(SDWebImageActivityIndicator.grayLarge)
                        .transition(.fade(duration: 0.5))
                        .aspectRatio(contentMode: .fit)
                        .matchedGeometryEffect(id: selectedPhotoURL?.absoluteString ?? "", in: namespace)
                        .edgesIgnoringSafeArea(.all)
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                        .onTapGesture {
//                            selectedPhotoURL = nil
                        }
                        .animation(.spring(), value: 1)
                }
        } else {
            VStack(alignment: .leading) {
                HStack(alignment: .top, spacing: 12) {
                    //VStack {
                        profileView
                            .frame(width: 56, height: 56)
                        
                        //                    DottedLine()
                        //                        .stroke(style: StrokeStyle(lineWidth: 2, dash: [3]))
                        //                        .frame(width: 2, height: 100)
                        //                        .foregroundColor(Color.orange)
                   // }
                    //                    .padding(.leading)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(firstPost.fullname)
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(Color("AdaptiveColor"))
                            
                            //                        Text("@\(post.username) •")
                            //                            .foregroundColor(.gray)
                            
                            Text(firstPost.timestampString)
                                .foregroundColor(.gray)
                        }
                        
                        HStack {
                            Text(BIBLE_MANAGER.getCaptionForPost(post: firstPost))
//                            TextWithLinks(string: caption, fontSize: 14, dynamicHeight: $height) { url in
//                                openBrowserWith(url: url.absoluteString)
//                            }
                            .frame(minHeight: height)
                            .fixedSize(horizontal: false, vertical: false)
                            .padding()
                            
                            //                        Text(firstPost.caption)
                            //                            .multilineTextAlignment(.leading)
                            //                            .foregroundColor(Color("AdaptiveColor"))
                            //                            .padding()
                        }
                        
                        VerseInfoView()
                        
                        
                        if firstPost.media.count > 0 {
                            let columns = Array(repeating: GridItem(.flexible()), count: 2)
                            LazyVGrid(columns: columns, spacing: 10) {
                                ForEach(firstPost.media.indices, id: \.self) { index in
                                    let media = firstPost.media[index]
                                    MorePhotoView(media: media) {
                                        
                                    } deleteAction: {
                                        print(index)
                                    }
//                                    .matchedGeometryEffect(id: media.imageURL, in: namespace)
//                                    .onTapGesture {
//                                        if media.mediaType == .photo {
//                                            selectedPhotoURL = URL(string: media.imageURL)
//                                        }
//                                    }
                                }
                            }
                            .padding(.horizontal)
                            Spacer(minLength: 20)
                        }
                        
                        PostActionView(post: firstPost)
                        Divider()
                    }
                    
                }
                //            .padding(.bottom)
                //            .padding(.trailing)
                
                if posts.count > 1 {
                    HStack(spacing: 20) {
                        profileView
                            .frame(width: 30, height: 30)
                        
                        Button {
                            showMorePosts.toggle()
                        } label: {
                            Text(showMorePosts ? "Read less" : "Read more")
                        }
                    }
                }
                
//                if showMorePosts {
//                    ForEach(Array(posts.dropFirst())) { post in
//                        NavigationLink(destination: PostDetailView(post: post)) {
//                            ThreadPostCell(post: post)
//                        }
//                        .buttonStyle(PlainButtonStyle())
//                    }
//                    .padding()
//                }
                
            }
            .padding(.leading, -16)
            .background(NavigationLinksView())
            //post.multiPostId == previousPost?.multiPostId ? 16 :
        }
    }
    
    init(posts: [Post]) {
        self.posts = posts
    }
}

// MARK: - View Functions
// MARK: -
extension PostCell {
    
    private func NavigationLinksView() -> some View {
        
        ZStack {
            NavigationLink(isActive: $showMorePosts) {
                PostDetailView(posts: posts)
            } label: {
                EmptyView()
            }

        }
    }
    
    private func VerseInfoView() -> some View {
        let verseInfo = BIBLE_MANAGER.getVerseInfo(post: firstPost)
        return Text(verseInfo)
            .font(.system(size: 12))
            .foregroundColor(.gray)
            .contentShape(Rectangle())
            .onTapGesture {
                showVerseView.toggle()
            }
            .isVisible(verseInfo.isNotEmpty)
            .trailing()
            .sheet(isPresented: $showVerseView) {
                NavigationView {
                    VersesView(
                        book: BIBLE_MANAGER.getBook(verseInfo: verseInfo),
                        selectedChapIndex: BIBLE_MANAGER.getChapter(verseInfo: verseInfo),
                        versesToShow: BIBLE_MANAGER.getVerses(verseInfo: verseInfo),
                        isFromPostView: false,
                        bibleVerse: .constant(""),
                        isDismiss: .constant(false))
                }
            }
    }
    
}
