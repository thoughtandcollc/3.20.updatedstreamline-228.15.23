//
//  ReadingDetailView.swift
//  streamline
//
//  Created by Matt Forgacs on 7/31/21.
//

import SwiftUI
import Kingfisher

struct ReadingDetailView: View {
    let reading:  Reading
   // let margin: Margin
    @State var clickedOnMe: Bool = false
 //   @State var annotate: Annotate!
//    @State var user: User?

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                KFImage(URL(string: reading.profileImageUrl))
                    .resizable()
                    .scaledToFill()
                    .clipped()
                    .frame(width: 56, height: 56)
                    .cornerRadius(28)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(reading.fullname)
                        .font(.system(size: 14, weight: .semibold))
                    
                    Text("@Bible")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
            }
        }
            
            Text(reading.caption)
                .font(.system(size: 22))
            
            Text(reading.detailedTimestampString)
                .font(.system(size: 14))
                .foregroundColor(.gray)
            
            Divider()
            
            VStack(alignment: .center) {
                ReadingActionView(reading: reading)
                
            Divider()
            }
                //CommentView(reading: reading, clickedOut: $clickedOnMe)
               // SadComments(reading: reading)
                LastChanceCellView()
            
            
            
            Spacer()
        } .padding()

    }
}
        
        


