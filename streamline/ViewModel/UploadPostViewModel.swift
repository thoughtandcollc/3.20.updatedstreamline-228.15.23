//
//  UploadPostViewModel.swift
//  streamline
//
//  Created by Matt Forgacs on 5/28/21.
//

import SwiftUI
import Firebase
import FirebaseStorage

class UploadPostViewModel: ObservableObject {
    @Binding var isPresented: Bool
    @Published var uploadToMyGroup = false
    @Published var isLoading: Bool = false
    @Published var captions: [PostCaptionViewModel] = []
//    @Published var morePhotos: [String] = [""]
    @Published var selectedPhotosAndVideosURL: [MTMedia] = [MTMedia.empty]
    private var uploadedPhotosURLs: [String] = []
    var captionsListForUploading: [PostCaptionViewModel] = []

    init(isPresented: Binding<Bool>) {
        self._isPresented = isPresented
    }
    
    func addCaption(text: String) {
        self.captions.insert(.init(text: text), at: 0)
        self.captionsListForUploading.insert(.init(text: text), at: 0)
    }
    
    func removeCaption(id: UUID) {
        guard let index = self.captions.firstIndex(where: {$0.id == id}) else {
            return
        }
        
        self.captions.remove(at: index)
    }
    
    func setImageInMorePhotos(media: MTMedia) {
        let index = selectedPhotosAndVideosURL.count - 1
        selectedPhotosAndVideosURL[index] = media
        if selectedPhotosAndVideosURL.count < 4 {
            selectedPhotosAndVideosURL.append(MTMedia.empty)
        }
    }
    
    func deletePhoto(at index: Int) {
        let photos = selectedPhotosAndVideosURL.filter({$0.mediaType != .empty}) //get non empty list
        
        // if selected photos is equal to 4 that means all images are selected and in that case only remove the last one and append new empty view so that user can add new one
        if photos.count == 4 {
            self.selectedPhotosAndVideosURL.remove(at: index)
            selectedPhotosAndVideosURL.append(MTMedia.empty)
        } else {
            self.selectedPhotosAndVideosURL.remove(at: index)
//            selectedPhotosAndVideosURL[selectedPhotosAndVideosURL.count - 1] = MTMedia.empty
        }
    }
    
    func uploadPostWithPhotos(groupId: String) {
        isLoading = true
        let postGroup = DispatchGroup()

        self.selectedPhotosAndVideosURL.filter({$0.mediaType != .empty}).forEach { media in
            postGroup.enter()
            uploadPhotoInFirestore(media: media, groupId: groupId) { downloadedURL in
                print("Downloaded image url => \(downloadedURL)")

                self.uploadedPhotosURLs.append(downloadedURL)
                postGroup.leave()
            }
        }
        
        postGroup.notify(queue: DispatchQueue.main) {
            print(self.uploadedPhotosURLs)
            self.uploadPosts(groupId: groupId)
        }
    }
    
    fileprivate func uploadPhotoInFirestore(media: MTMedia, groupId: String, completion: @escaping (String)-> Void) {
        guard let url = URL(string: media.imageURL) else {
            return
        }

        let storageRef = Storage.storage().reference().child("postsImages/\(groupId)/\(UUID().uuidString)_\(Int(Date().timeIntervalSince1970))\(media.mediaType == .photo ? ".jpeg" : ".mp4")")
        let metadata = StorageMetadata()
        metadata.contentType = media.mediaType == .photo ? "image/jpeg" : "video/mp4"

        storageRef.putFile(from: url, metadata: nil, completion: { metadata, error in
            if let error = error {
                print("Error uploading photo: \(error.localizedDescription)")
                self.isLoading = false
                return
            }
            
            storageRef.downloadURL { url, error in
                if let error = error {
                    print("Error getting Download URL photo: \(error.localizedDescription)")
                    self.isLoading = false
                    return
                }
                completion(url?.absoluteString ?? "")
                print("URL => \(url)")
            }
        })
    }
    
    func uploadPosts(groupId: String?) {
        let postGroup = DispatchGroup()
        isLoading = true

        let multiPostId = String(Int(Date().timeIntervalSince1970))
        self.captionsListForUploading.forEach { caption in
            postGroup.enter()
            uploadPost(caption: caption.text, groupId: groupId, multiPostId: multiPostId) {
                postGroup.leave()
            }
        }
        
        postGroup.notify(queue: DispatchQueue.main) {
            self.isLoading = false
            self.isPresented = false
        }
    }
    
    func uploadPost(caption: String, groupId: String?, multiPostId: String, completion: @escaping ()-> Void) {
        guard let user = AuthViewModel.shared.user else { return }
        let docRef = COLLECTION_POSTS.document()
        
        var data: [String: Any] = ["uid": user.id,
                                   "multiPostId": multiPostId,
                                   "caption": caption,
                                   "fullname": user.fullname,
                                   "timestamp": Timestamp(date: Date()),
                                   "profileImageUrl": user.profileImageUrl,
                                   "likes": "0",
                                   "imagesURLs": uploadedPhotosURLs,
                                   "id": docRef.documentID]
        
        if let groupId = groupId {
            data.updateValue(groupId, forKey: "myGroupId")
        }
        
        docRef.setData(data) { _ in
            completion()
        }
        print("DEBUG: Successfully Uploaded Post")
    }
}
