//
//  ImageViewer.swift
//  streamline
//
//  Created by Tayyab Ali on 18/05/2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct ImageViewer: View {
//    @Namespace var namespace
    let imageURL: URL
    @Binding var showFullScreenImage: Bool
    
    var body: some View {
        VStack {
            ZStack(alignment: .topTrailing) {
                AnimatedImage(url: imageURL)
                    .indicator(SDWebImageActivityIndicator.grayLarge)
                    .resizable()
                    .scaledToFit()
                    .edgesIgnoringSafeArea(.all)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                Button {
                    showFullScreenImage = false
                } label: {
                    Image("cancel-c")
                        .padding(.top, 20)
                        .padding(.horizontal)
                }
            }
        }
        .background(Color.black)
    }
}

struct ImageViewer_Previews: PreviewProvider {
    static var previews: some View {
        ImageViewer(imageURL: URL(string: "https://ptsse.co.id/assets/gambar_galeri/images.png")!, showFullScreenImage: .constant(true))
    }
}
