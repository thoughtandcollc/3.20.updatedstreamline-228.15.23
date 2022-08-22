//
//  ReplyPostCell.swift
//  streamline
//
//  Created by Matt Forgacs on 6/15/21.
//

import SwiftUI

struct ReplyPostCell: View {
    let replying: Replying
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top, spacing: 12) {
            Image("bibl2")
                .resizable()
                .scaledToFill()
                .clipped()
                .frame(width: 56, height: 56)
                .cornerRadius(56 / 2)
                .padding(.leading)
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(replying.fullname)
                            .font(.system(size: 16, weight: .semibold))
                    }
                    
                    Text(replying.caption)
                }
            } .padding(.bottom)
            .padding(.trailing)
        
        HStack {
            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                Image(systemName: "bubble.left")
                    .font(.system(size: 16))
                    .frame(width: 32, height: 32)
             Spacer()
            })
            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                Image(systemName: "pin")
                    .font(.system(size: 16))
                    .frame(width: 32, height: 32)
              
            })
        }
        .foregroundColor(.gray)
        .padding(.horizontal)
        
        Divider()
    }
    .padding(.leading, -16)
    }
}

