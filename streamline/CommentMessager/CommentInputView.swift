//
//  CommentInputView.swift
//  streamline
//
//  Created by Matt Forgacs on 12/14/21.
//

import SwiftUI

struct CommentInputView: View {
    @Binding var commentText: String
    
    var action: () -> Void
    
    var body: some View {
        VStack {
            Rectangle()
                .foregroundColor(Color(.separator))
                .frame(width: UIScreen.main.bounds.width, height: 0.75)
                .padding(.bottom, 8)
            
            HStack {
                TextField("Add a Comment", text: $commentText)
                    .textFieldStyle(PlainTextFieldStyle())
                    .frame(minHeight: 30)
//
                Button {
                    
                } label: {
                    Text("Send")
                        .foregroundColor(.orange)
                }

                
            }
            .padding(.horizontal)
        }
    }

}
