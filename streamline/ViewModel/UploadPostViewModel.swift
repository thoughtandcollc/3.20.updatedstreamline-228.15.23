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
    
    func uploadPostWithPhotos(group: Group) {
        isLoading = true
        let postGroup = DispatchGroup()

        self.selectedPhotosAndVideosURL.filter({$0.mediaType != .empty}).forEach { media in
            postGroup.enter()
            uploadPhotoInFirestore(media: media, groupId: group.id) { downloadedURL in
                print("Downloaded image url => \(downloadedURL)")

                self.uploadedPhotosURLs.append(downloadedURL)
                postGroup.leave()
            }
        }
        
        postGroup.notify(queue: DispatchQueue.main) {
            print(self.uploadedPhotosURLs)
            self.uploadPosts(group: group)
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
    
    func uploadPosts(group: Group) {
        let postGroup = DispatchGroup()
        isLoading = true

        let multiPostId = String(Int(Date().timeIntervalSince1970))
        self.captionsListForUploading.forEach { caption in
            postGroup.enter()
            uploadPost(caption: caption.text, group: group, multiPostId: multiPostId) {
                postGroup.leave()
            }
        }
        
        postGroup.notify(queue: DispatchQueue.main) {
            self.isLoading = false
            self.isPresented = false
        }
    }
    
    func uploadPost(caption: String, group: Group, multiPostId: String, completion: @escaping ()-> Void) {
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
        

        data.updateValue(group.id, forKey: "myGroupId")
        
        docRef.setData(data) { _ in
            self.sendNotification(group: group)
            completion()
        }
        print("DEBUG: Successfully Uploaded Post")
    }
    
    private func sendNotification(group: Group) {
        
        guard let currentUser = AuthViewModel.shared.user else { return }
        guard group.createdBy == currentUser.id else { return }
        let receiverIds = group.joinedUsers?.filter({ $0 != group.createdBy }) ?? []
        
        for receiverId in receiverIds {
            
            let query = COLLECTION_USERS.document(receiverId).collection("notifications").document()
            
            let notification = AppNotification(id: query.documentID,
                                               senderId: currentUser.id,
                                               username: currentUser.fullname,
                                               receiverId: receiverId,
                                               profileImageUrl: currentUser.profileImageUrl,
                                               type: .posted,
                                               groupId: group.id,
                                               groupName: group.name,
                                               title: "New Post",
                                               body: "\(currentUser.fullname) posted in group \(group.name).",
                                               timestamp: Timestamp(date: Date()))
            
            try? query.setData(from: notification)
            
        }
        
        
    }
}
