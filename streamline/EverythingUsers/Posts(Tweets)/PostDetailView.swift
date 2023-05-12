//
//  PostDetailView.swift
//  streamline
//
//  Created by Matt Forgacs on 5/29/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct PostDetailView: View {
    
    @StateObject var postModel: PostDetailViewModel
    
    @Environment(\.presentationMode) var presentationMode // for dismissing this view
    
    let post: Post
    
    @State private var height: CGFloat = .zero
    let columns = Array(repeating: GridItem(.flexible()), count: 2)
    
    @State private var showVerseView = false // show verse view
    var verseInfo = ""
    var caption = ""
    
    init(post: Post) {
        _postModel = StateObject(wrappedValue: PostDetailViewModel(post: post))
        self.post = post
        
        if post.caption.contains(";") {
            caption = post.caption.components(separatedBy: ";").first ?? ""
            verseInfo = post.caption.components(separatedBy: ";").last ?? ""
        }
        else {
            caption = post.caption
            verseInfo = ""
        }
    }
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 16) {
            
            PostOwnerInfoView()
            
            PostTextView()
            
            PostMediaView()
            
            PostTimeStampView()
            
            PostActionsView()
            
            PostCommentsView(viewModel: .init(userId: post.uid, postId: post.id))
            
            Spacer()
            
            PostDeleteButtonView()
            
        }
        .padding()
        
        
    }
    
}

// MARK: - Helper View Functions
// MARK: -
extension PostDetailView {
    
    private func PostOwnerInfoView() -> some View {
        
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
    
    private func PostTextView() -> some View {
        
        TextWithLinks(string: caption, fontSize: 22, dynamicHeight: $height) { url in
            openBrowserWith(url: url.absoluteString)
        }
        .frame(minHeight: height)
        .fixedSize(horizontal: false, vertical: true)
        .padding()
        
    }
    
    private func PostMediaView() -> some View {
        
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
    
    private func PostTimeStampView() -> some View {
        
        HStack {
            
            Text(post.detailedTimestampString)
                .font(.system(size: 14))
                .foregroundColor(.gray)
                .padding(.leading)
            
            VerseInfoView()
            
        }
        
    }
    
    private func PostActionsView() -> some View {
        
        VStack {
            Divider()
                PostActionView(post: post)
            Divider()
        }
        
    }
    
    private func PostDeleteButtonView() -> some View {
        
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
    
    private func VerseInfoView() -> some View {
        
        Text(verseInfo)
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
                    VerseDetailView(book: getBook(), chapIndex: getChapter(), verseIndex: getVerse(), bibleVerse: .constant(""), isDismiss: .constant(false))
                }
            }
    }
    
}

// MARK: - Helper Functions
// MARK: -
extension PostDetailView {
    
    private func getBook() -> Book {
        let bookName = verseInfo.components(separatedBy: ",").first ?? ""
        let book = BibleManager.shared.books.first(where: {$0.name == bookName}) ?? BibleManager.shared.books.first!
        return book
    }
    
    private func getChapter() -> Int {
        var chapNum = verseInfo.components(separatedBy: "Chapter: ").last ?? ""
        chapNum = chapNum.components(separatedBy: " ").first ?? ""
        var chapIndex = Int(chapNum) ?? 0
        if chapIndex != 0 { chapIndex -= 1 }
        return chapIndex
    }
    
    private func getVerse() -> Int {
        var verseIndex = Int(String(verseInfo.components(separatedBy: "Verse: ").last ?? "")) ?? 0
        if verseIndex != 0 { verseIndex -= 1 }
        return verseIndex
    }
    
}
