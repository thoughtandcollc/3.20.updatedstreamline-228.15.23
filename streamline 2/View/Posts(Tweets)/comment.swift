//
//  comment.swift
//  streamline
//
//  Created by Matt Forgacs on 8/3/21.
//

import SwiftUI
import Kingfisher

struct comment: View {
//    @ObservedObject var viewModel: ReplyViewModel
//      var reply: [Reply]

    var body: some View {
            
        List(0 ..< 5) { item in
            Image("Focus1")
                .resizable()
                .scaledToFill()
                .clipped()
                .frame(width: 56, height: 56)
                .cornerRadius(28)
                .padding(.trailing)
                .padding(.vertical)

            VStack(alignment: .leading) {
                Text("@Anonymous Member")
                .foregroundColor(.gray)

                Text("I am always leaving insightful feedback on the readings for my group")
                    .font(.system(size: 16))

            }

        }
    }
        }
struct comment_Previews: PreviewProvider {
    static var previews: some View {
        comment()
    }
}
