//
//  ImagePicker.swift
//  streamline
//
//  Created by Matt Forgacs on 5/26/21.
//

import SwiftUI
import AVFoundation

// MARK: - Media Type
enum MTMediaType: String {
    case photo
    case video
    case photoAndVideo
    case empty
    var value: [String] {
        
        switch self {
        case .photo:
            return ["public.image"]
        case .video:
            return ["public.movie"]
        case .empty:
            return []
        default:
            return ["public.image", "public.movie"]
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    //    @Binding var image: UIImage?
    //    @Environment(\.presentationMode) var mode
    var mediaTypes: MTMediaType = .photo
    let completion: ((UIImage, URL)-> Void)
    var videoCompletion: ((MTMedia)-> Void)? = nil

    func makeCoordinator() -> Coordinator {
        Coordinator(mediaTypes: mediaTypes, completionHandler: completion, videoCompletion: videoCompletion)
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.mediaTypes = mediaTypes.value
        picker.allowsEditing = true
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}

extension ImagePicker {
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        //        let parent: ImagePicker
        var mediaTypes: MTMediaType = .photo
        let completion: ((UIImage, URL)-> Void)?
        let videoCompletion: ((MTMedia)-> Void)?

        init(mediaTypes: MTMediaType = .photo, completionHandler: @escaping ((UIImage, URL) -> Void), videoCompletion: ((MTMedia)-> Void)?) {
            //            self.parent = parent
            self.mediaTypes = mediaTypes
            self.completion = completionHandler
            self.videoCompletion = videoCompletion
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//            guard let image = info[.originalImage] as? UIImage else { return }
//            if let imageURL = saveImageAndGetUrl(image: image) {
//                completion?(image, imageURL)
//            } else {
//                print("Error while saving image")
//            }
//
            if let image = info[.editedImage] as? UIImage {
                
                if let imageURL = saveImageAndGetUrl(image: image) {
                    
                    completion?(image, imageURL)
                } else {
                    print("Error while saving image")
                }
                
                print("Capture Image Picked")
                picker.dismiss(animated: true, completion: nil)
            }

            
            //Picked Video
            if let mediaType = info[.mediaURL] as? URL {
                
                self.selectedVideo(videoURL: mediaType, picker: picker)
            }
            //            parent.image = image
            //            parent.mode.wrappedValue.dismiss()
        }
        
        private func selectedVideo(videoURL: URL, picker: UIImagePickerController) {
            
            if let videoURl = copyVideoAndGetUrl(videoUrl: videoURL) {
                let media = MTMedia(imageURL: videoURl.absoluteString, mediaType: .video, thumbnail: "")
                self.videoCompletion?(media)
//                AVAsset(url: URL(string: videoURl.absoluteString)!).generateThumbnail { [weak self] (imageURL) in
//                    DispatchQueue.main.async {
//                        guard let imageURL = imageURL else { return }
//
////                        let thumbnailImageURL = saveImageAndGetUrl(image: image)
//                        let media = MTMedia(imageURL: videoURl.absoluteString, mediaType: .video, thumbnail: imageURL.absoluteString)
//                        self?.videoCompletion?(media)
//                    }
//                }
            } else {
                print("Error while Picking video")
            }
            
            print("Video Picked")
            picker.dismiss(animated: true, completion: nil)
        }
        
   
        
        func copyVideoAndGetUrl(videoUrl: URL) -> URL? {
            
            let documentsDirectory = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
            let fileName = Date().timeIntervalSince1970
            let fileURL = documentsDirectory.appendingPathComponent("\(fileName).mov")
            
            guard let data = try? Data(contentsOf: videoUrl) else { return nil }
            
            do {
                try data.write(to: fileURL)
                return fileURL
                
            } catch let error {
                print("error saving file with error", error)
                return nil
            }
        }
    }
}

func saveImageAndGetUrl(image: UIImage)-> URL? {
    
    let directoryUrl = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
    
    let fileName = Int(Date().timeIntervalSince1970)
    let fileURL = directoryUrl.appendingPathComponent("\(fileName).jpeg")
    guard let data = image.jpegData(compressionQuality: 0.2) else { return nil }
    
    do {
        try data.write(to: fileURL)
        print("Saved Image URL => \(fileURL)")
        return fileURL
        
    } catch let error {
        print("error saving file with error", error)
        return nil
    }
}

extension AVAsset {

    func generateThumbnail(completion: @escaping (URL?) -> Void) {
        DispatchQueue.global().async {
            let imageGenerator = AVAssetImageGenerator(asset: self)
            let time = CMTime(seconds: 0.0, preferredTimescale: 600)
            let times = [NSValue(time: time)]
            imageGenerator.generateCGImagesAsynchronously(forTimes: times, completionHandler: { _, image, _, _, _ in
                if let cgimage = image {
                    let image = UIImage(cgImage: cgimage)
                    let thumbnailImageURL = saveImageAndGetUrl(image: image)

                    completion(thumbnailImageURL)
                } else {
                    completion(nil)
                }
            })
        }
    }
}
