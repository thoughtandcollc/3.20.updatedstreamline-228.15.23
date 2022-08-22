//
//  ChapterCell.swift
//  streamline
//
//  Created by Matt Forgacs on 9/24/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct ChapterCell: View {
    let chapter: Chapter
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center, spacing: 12) {
                AnimatedImage(url: URL(string: chapter.profileImageUrl))
                    .indicator(SDWebImageActivityIndicator.grayLarge)
                    .resizable()
                    .scaledToFill()
                    .clipped()
                    .frame(width: 56, height: 56)
                    .cornerRadius(56 / 2)
                    .padding(.leading)
                
                VStack(alignment: .center) {
                    HStack {
                        Text(chapter.fullname)
                            .font(.title)
                            .foregroundColor(Color("AdaptiveColor"))
                    
         ///               Text(annotations.timestamp)
            //            .foregroundColor(.gray)
                    }
                    
        //            Text(chapter.caption)
          //              .foregroundColor(Color("AdaptiveColor"))
                    
                }
            } .padding(.bottom)
            .padding(.trailing)
                
            Divider()
        }
        .padding(.leading, -16)
    }
}


//struct ChapterCell_Previews: PreviewProvider {
//    static var previews: some View {
//        ChapterCell()
//    }
//}
