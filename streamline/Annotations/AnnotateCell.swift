//
//  PlaceHold.swift
//  streamline
//
//  Created by Matt Forgacs on 9/14/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct AnnotateCell: View {
    let annotate: Annotate
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top, spacing: 12) {
                AnimatedImage(url: URL(string: annotate.profileImageUrl))
                    .indicator(SDWebImageActivityIndicator.grayLarge)
                    .resizable()
                    .scaledToFill()
                    .clipped()
                    .frame(width: 56, height: 56)
                    .cornerRadius(56 / 2)
                    .padding(.leading)
                
                VStack(alignment: .leading) {
                    HStack {
                        Text(annotate.fullname)
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(Color("AdaptiveColor"))
                    
         ///               Text(annotations.timestamp)
            //            .foregroundColor(.gray)
                    }
                    
                    Text(annotate.caption)
                        .foregroundColor(Color("AdaptiveColor"))
                    
                }
            } .padding(.bottom)
            .padding(.trailing)
                
            Divider()
        }
        .padding(.leading, -16)
    }
}
