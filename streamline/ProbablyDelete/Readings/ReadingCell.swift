//
//  ReadingCell.swift
//  streamline
//
//  Created by Matt Forgacs on 6/1/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct ReadingCell: View {
    let reading: Reading
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top, spacing: 12) {
                AnimatedImage(url: URL(string: reading.profileImageUrl))
                    .indicator(SDWebImageActivityIndicator.grayLarge)
                    .resizable()
                    .scaledToFill()
                    .clipped()
                    .frame(width: 56, height: 56)
                    .cornerRadius(56 / 2)
                    .padding(.leading)
                
                VStack(alignment: .leading) {
                    HStack {
                        Text(reading.fullname)
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(Color("AdaptiveColor"))
                    Text("@Bible •")
                        .foregroundColor(.gray)
                        
                        Text(reading.timestampString)
                        .foregroundColor(.gray)
                    }
                    
                    Text(reading.caption)
                        .foregroundColor(Color("AdaptiveColor"))
                    
                }
            } .padding(.bottom)
            .padding(.trailing)
            
            ReadingActionView(reading: reading)
                
            Divider()
        }
        .padding(.leading, -16)
    }
}
