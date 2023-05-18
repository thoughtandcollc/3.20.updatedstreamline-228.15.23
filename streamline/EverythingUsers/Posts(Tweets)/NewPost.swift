//
//  NewPost.swift
//  streamline
//
//  Created by Matt Forgacs on 5/25/21.
//
import SwiftUI
import SDWebImageSwiftUI

struct NewPost: View {
    
    @Binding var isPresented: Bool
    @State var captionText: String = ""
    @ObservedObject var viewModel: UploadPostViewModel
    @State var showImagePicker = false
    let columns = Array(repeating: GridItem(.flexible()), count: 3)
    @State private var showBibleView = false // for showing/hiding bible screen
    @State var bibleVerse = ""
    @State var verseInfo = ""

    var post: Post?
    var groupId: String
    
    init(isPresented: Binding<Bool>, groupId: String) {
        self._isPresented = isPresented
        self.groupId = groupId
        self.viewModel = UploadPostViewModel(isPresented: isPresented)
        UITableView.appearance().backgroundColor = UIColor.clear
    }
    
    var body: some View {
        
        NavigationView {
            
            VStack(alignment: .leading) {
                
                TopInfoView()
                
                VerseInfoView()
                
                TextInfoView()
                
                ImagesListView()
                
                Spacer()
                
                EditPostView()
                
                Spacer()
            }
            .padding()
            .navigationBarItems(leading: NavigationLeadingView(),
                                trailing: NavigationTrailingView())
            .toast(isPresenting: $viewModel.isLoading, alert: { .init(type: .loading)})
            .sheet(isPresented: $showBibleView, onDismiss: {
                if bibleVerse.isNotEmpty {
                    var comp = bibleVerse.components(separatedBy: ";")
                    if captionText.isEmpty { captionText = comp.first ?? "" }
                    else { captionText = captionText + "\n\n" + (comp.first ?? "") }
                    verseInfo = comp.last ?? ""
                    
                }
            }) {
                NavigationView { BooksView(isFromPostView: true, bibleVerse: $bibleVerse, isDismiss: $showBibleView) }
            }
        }
    }
    
}

// MARK: - Helper View Functions
// MARK: -
extension NewPost {
    
    private func TopInfoView() -> some View {
        VStack {
            
            HStack(alignment: .top) {
                if let user = AuthViewModel.shared.user {
                    AnimatedImage(url: URL(string: user.profileImageUrl))
                        .indicator(SDWebImageActivityIndicator.grayLarge)
                        .resizable()
                        .scaledToFill()
                        .clipped()
                        .frame(width: 64, height: 64)
                        .cornerRadius(32)
                }
                
                TextArea("What are you thinking?", text: $captionText, characterLimitEnabled: true, limitCompletedAction: {
                    viewModel.addCaption(text: captionText)
                })
                .frame(height: 70)
                Spacer()
                
            }
            
            Divider()
        }
    }
    
    private func VerseInfoView() -> some View {
        
        Text(verseInfo)
            .font(.system(size: 12))
            .foregroundColor(.gray)
            .isVisible(verseInfo.isNotEmpty)
            .trailing()
    }
    
    private func TextInfoView() -> some View {
        
        HStack {
            
            NavigationLink {
                ScanTextArea()
            } label: {
                Image(systemName: "bolt")
                    .font(.system(size: 18))
                    .foregroundColor(.orange)
                    .padding(.vertical)
            }
            
            Spacer()
            
            Button {
                showBibleView.toggle()
            } label: {
                Text("Add Bible Verse")
            }

            
            Spacer()
            
            Text("\(captionText.count)/240")
                .foregroundColor(Color(.placeholderText))
                .font(.system(size: 14))
                .padding(.trailing, 20)
        }
        
    }
    
    private func ImagesListView() -> some View {
        
        LazyVGrid(columns: columns, spacing: 10) {
            ForEach(Array(viewModel.selectedPhotosAndVideosURL.enumerated()), id: \.element.id) { index, media in
//                            let media = viewModel.selectedPhotosAndVideosURL[index]
                MorePhotoView(media: media) {
                    self.showImagePicker = true
                } deleteAction: {
                    print(index)
                    self.viewModel.deletePhoto(at: index)
                }
                .sheet(isPresented: $showImagePicker, content: {
                    ImagePicker(mediaTypes: .photoAndVideo) { (image, imageURL) in
                        let media = MTMedia(imageURL: imageURL.absoluteString, mediaType: .photo, thumbnail: imageURL.absoluteString)
                        self.viewModel.setImageInMorePhotos(media: media)
                    } videoCompletion: { media in
                        self.viewModel.setImageInMorePhotos(media: media)
                    }

                })
            }
        }
        .isVisible(viewModel.captions.count < 1)
        
    }
    
    private func EditPostView() -> some View {
        
        List {
            ForEach(viewModel.captions) { caption in
                Text(caption.text)
                    .font(.body)
                    .swipeActions(allowsFullSwipe: false){
                        
                        Button(role: .destructive) {

                            withAnimation {
                                viewModel.removeCaption(id: caption.id)
                            }
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }

                        Button {
                            self.captionText = caption.text
                            withAnimation {
                                viewModel.removeCaption(id: caption.id)
                            }
                        } label: {
                            Label("Edit", systemImage: "pencil")
                        }
                        .tint(.blue)
                    }
            }
        }
        
    }
    
    private func NavigationLeadingView() -> some View {
        Button(action: {
            isPresented.toggle()
        }, label: {
            Text("Cancel")
                .foregroundColor(Color("AdaptiveColor"))
        })
    }
    
    private func NavigationTrailingView() -> some View {
        
        Button(action: {
            
            // if text field text is not empty then add it to list as well
            if verseInfo.isNotEmpty {
                captionText.append(";\(verseInfo)")
            }
            
            if captionText != "" {
                viewModel.captionsListForUploading.insert(.init(text: captionText), at: 0)
            }
            
            if viewModel.captionsListForUploading.count == 1 && viewModel.selectedPhotosAndVideosURL.count > 1 {
                viewModel.uploadPostWithPhotos(groupId: groupId)
                return
            }
            
            viewModel.uploadPosts(groupId: groupId)
            
        }, label: {
            Text("Post")
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background((captionText.isEmpty && viewModel.captions.isEmpty) ? Color.gray : Color.orange)
                .foregroundColor(.white)
                .clipShape(Capsule())
                .disabled(captionText.isEmpty && viewModel.captions.isEmpty)
        })
    }
    
}


// MARK: - Preview
// MARK: -
struct NewPost_Previews: PreviewProvider {
    static var previews: some View {
        NewPost(isPresented: .constant(true), groupId: "")
    }
}
