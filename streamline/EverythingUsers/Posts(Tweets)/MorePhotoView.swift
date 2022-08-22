//
//  MorePhotoView.swift
//  streamline
//
//  Created by Tayyab Ali on 13/05/2022.
//

import SwiftUI
import SDWebImageSwiftUI
import AVFoundation

struct MorePhotoView: View {
    // MARK: - PROPERTIES
    let media: MTMedia
    let action: ()-> Void
    let deleteAction: ()-> Void
    var height: CGFloat = 0
    @State var thumbnailImageURL: URL?
    @State var showFullScreenImage = false
    @State var showVideoPlayer = false
//    @Namespace var namespace
    
    var body: some View {
        
        if media.imageURL.isEmpty {
            GeometryReader { proxy in
                Button(action: action) {
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(Color("dashColor"), style: StrokeStyle(lineWidth: 1, dash: [5]))
                        .overlay(
                            Image("plus")
                                .renderingMode(.template)
                                .foregroundColor(Color("AdaptiveColor"))
                        )
                }
            }
            .frame(height: 120)
            
        } else {
            
            ZStack(alignment: .topTrailing) {
                //                GeometryReader { proxy in
                
                AnimatedImage(url: media.mediaType == .photo ? URL(string: media.imageURL) : thumbnailImageURL)
                    .indicator(SDWebImageActivityIndicator.grayLarge)
                    .resizable()
                    .scaledToFill()
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50)
                    .cornerRadius(6)
                    .clipped()
//                    .matchedGeometryEffect(id: "fullscreen", in: namespace)
                    .onAppear {
                        if media.mediaType == .photo {
//                            imageURL = URL(string: media.imageURL)
                        } else {
                            thumbnailImageURL = URL(string: "https://ptsse.co.id/assets/gambar_galeri/images.png")
                            AVAsset(url: URL(string: media.imageURL)!).generateThumbnail { imageURL in
                                self.thumbnailImageURL = imageURL
                            }
                        }
                    }
                    .onTapGesture {
                        if media.mediaType == .photo {
                            showFullScreenImage.toggle()
                            return
                        }
                        
                        showVideoPlayer.toggle()
                    }
                    .fullScreenCover(isPresented: $showFullScreenImage) {
                        ImageViewer(imageURL: URL(string: media.imageURL)!, showFullScreenImage: $showFullScreenImage)
                    }
                    .fullScreenCover(isPresented: $showVideoPlayer) {
                        PlayerViewController(videoURL: URL(string: media.imageURL)!)
                          .edgesIgnoringSafeArea(.all)
                    }
                if media.mediaType == .video {
                    Image("video-camera")
                        .resizable()
                        .foregroundColor(.white)
                        .frame(width: 30, height: 30)
                        .padding(5)
                }
                
                if !media.imageURL.starts(with: "https://") {
                    Button(action: deleteAction) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.red)
                            .frame(width: 20, height: 20)
                            .offset(x: 20, y: -20.0)
                            .padding(10)
                    }
                }
                //                }
            }
        }
    }
}
