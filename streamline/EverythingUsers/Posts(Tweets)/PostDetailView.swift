//
//  PostDetailView.swift
//  streamline
//
//  Created by Matt Forgacs on 5/29/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct PostDetailView: View {
    
    @Environment(\.presentationMode) var presentationMode // for dismissing this view
    
    @StateObject var postModel: PostDetailViewModel
    
    //let post: Post
    let posts: [Post]
    
    @State private var height: CGFloat = .zero
    let columns = Array(repeating: GridItem(.flexible()), count: 2)
    
    @State private var showVerseView = false // show verse view
    //var verseInfo = ""
    //var caption = ""
    
    init(posts: [Post]) {
        let post = posts.first ?? Post(dictionary: [:])
        self.posts = posts
        _postModel = StateObject(wrappedValue: PostDetailViewModel(post: post))
    }
    
    var body: some View {
        
        ScrollView {
            
            VStack(alignment: .leading, spacing: 16) {
                
                ForEach(Array(posts)) { post in
                    
                    VStack() {
                        
                        PostOwnerInfoView(post: post)
                        
                        PostTextView(post: post)
                        
                        PostMediaView(post: post)
                        
                        PostTimeStampView(post: post)
                        
                        PostActionsView(post: post)
                        
                    }
                    
                }
                
                // show comments if there is only one post
                if let post = posts.first, posts.count == 1 {
                    PostCommentsView(viewModel: .init(userId: post.uid, postId: post.id))
                }
                
                Spacer()
                
            }
            
        }
        .safeAreaInset(edge: .bottom, content: {
            if let post = posts.first, posts.count == 1 {
                PostDeleteButtonView(post: post)
            }
        })
        .padding()
        
        
    }
    
}

// MARK: - Helper View Functions
// MARK: -
extension PostDetailView {
    
    private func PostOwnerInfoView(post: Post) -> some View {
        
        HStack {
            
            //-------------------------------------------------- Post Owner Image
            
            AnimatedImage(url: URL(string: post.profileImageUrl))
                .indicator(SDWebImageActivityIndicator.grayLarge)
                .resizable()
                .scaledToFill()
                .clipped()
                .frame(width: 56, height: 56)
                .cornerRadius(28)
            
            //-------------------------------------------------- Post Owner Info
            
            VStack(alignment: .leading, spacing: 4) {
                
                Text(post.fullname)
                    .font(.system(size: 14, weight: .semibold))
                
                Text("@OnTheMargin")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                
            }
            
            Spacer()
            
            //-------------------------------------------------- Flag
            
            HStack(alignment: .top) {
                ReplyCell()
            }
            .padding()
        }
    }
    
    private func PostTextView(post: Post) -> some View {
        
        Text(BIBLE_MANAGER.getCaptionForPost(post: post))
            .font(.system(size: 22))
            .leading()
            .padding(.horizontal)
            .padding(.bottom)
        
    }
    
    private func PostMediaView(post: Post) -> some View {
        
        VStack {
            
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(Array(post.media.enumerated()), id: \.element.id) { index, media in
                    MorePhotoView(media: media) {
                    } deleteAction: {
                        print(index)
                    }
                }
            }
            .padding(.horizontal)
            Spacer(minLength: 20)
        }
        .isVisible(post.media.count > 0)
        
    }
    
    private func PostTimeStampView(post: Post) -> some View {
        
        HStack {
            
            Text(post.detailedTimestampString)
                .font(.system(size: 14))
                .foregroundColor(.gray)
                .padding(.leading)
            
            VerseInfoView(post: post)
                .isVisible(BIBLE_MANAGER.getVerseInfo(post: post) != "")
            
        }
        
    }
    
    private func PostActionsView(post: Post) -> some View {
        
        VStack {
            Divider()
            PostActionView(post: post)
            Divider()
        }
        
    }
    
    private func PostDeleteButtonView(post: Post) -> some View {
        
        Button {
            postModel.deletePost(post: post) { success in
                guard success else { return }
                presentationMode.wrappedValue.dismiss() // dismiss this view
            }
        } label: {
            
            Text("Delete Post")
        }
        .buttonStyle(.borderedProminent)
        .tint(.red)
        .center()
        .isVisible(isGroupOwner(memberId: userId, group: postModel.group) ||
                   isGroupSubLeader(memberId: userId, group: postModel.group) ||
                   userId == post.uid
        )

    }
    
    private func VerseInfoView(post: Post) -> some View {
        
        let verseInfo = BIBLE_MANAGER.getVerseInfo(post: post)
        
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
