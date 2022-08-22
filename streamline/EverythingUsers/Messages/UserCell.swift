//
//  UserCell.swift
//  streamline
//
//  Created by Matt Forgacs on 5/24/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct UserCell: View {
    let user: User
        
    var body: some View {
        HStack(spacing: 12) {
            AnimatedImage(url: URL(string: user.profileImageUrl))
                .indicator(SDWebImageActivityIndicator.grayLarge)
                .resizable()
                .scaledToFill()
                .clipped()
                .frame(width: 56, height: 56)
                .cornerRadius(28)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(user.fullname)
                    .font(.system(size: 14, weight: .semibold))
                
                
            }
            .foregroundColor(Color("AdaptiveColor"))        }
    }
}
