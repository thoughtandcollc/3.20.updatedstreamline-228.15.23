//
//  AnnotateInputView.swift
//  streamline
//
//  Created by Matt Forgacs on 9/13/21.
//
import SwiftUI

struct AnnotateInputView: View {
    @Binding var annotateText: String
    
    var action: () -> Void
    
    var body: some View {
        VStack {
            Rectangle()
                .foregroundColor(Color(.separator))
                .frame(width: UIScreen.main.bounds.width, height: 0.75)
                .padding(.bottom, 8)
            
            HStack {
                TextField("Notes...", text: $annotateText)
                    .textFieldStyle(PlainTextFieldStyle())
                    .frame(minHeight: 30)
                
                Button(action: action) {
                    Text("Send")
                        .bold()
                        .foregroundColor(.orange)
                }
            }
            .padding(.horizontal)
        }
    }
}
