//
//  LastChanceCell.swift
//  streamline
//
//  Created by Matt Forgacs on 10/5/21.
//

import SwiftUI
import Kingfisher

struct LastChanceCell: View {
    let margin: Margin
    
    var body: some View {
        VStack {
            HStack {
                KFImage(URL(string: margin.profileImageUrl))
                    .resizable()
                    .scaledToFill()
                    .clipped()
                    .frame(width: 28, height: 28)
                    .cornerRadius(28 / 2)
                    .padding(.leading)
                
                VStack {
                    HStack {
                        Text(margin.fullname)
                            .bold()
                    }
                    Text(margin.reply)
                        .foregroundColor(Color("AdaptiveColor"))
                }
                
         

            }
        }
    }
}

//struct LastChanceCell_Previews: PreviewProvider {
//    static var previews: some View {
//        LastChanceCell(reading: reading)
//    }
//}
//
//VStack(alignment: .leading) {
//    HStack(alignment: .top, spacing: 12) {
//        KFImage(URL(string: post.profileImageUrl))
//            .resizable()
//            .scaledToFill()
//            .clipped()
//            .frame(width: 56, height: 56)
//            .cornerRadius(56 / 2)
//            .padding(.leading)
//
//        VStack(alignment: .leading, spacing: 4) {
//            HStack {
//            Text(post.fullname)
//                    .font(.system(size: 20, weight: .semibold))
//                    .foregroundColor(Color("AdaptiveColor"))
//        //    Text("@NLChurch •")
//          //      .foregroundColor(.gray)
//
//            Text(post.timestampString)
//                .foregroundColor(.gray)
//            }
//
//            Text(post.caption)
//                .foregroundColor(Color("AdaptiveColor"))
//
//        }
//    }
//    .padding(.bottom)
//    .padding(.trailing)
//
//    PostActionView(post: post)
//
//    Divider()
//}
//.padding(.leading, -16)
//}
//}
