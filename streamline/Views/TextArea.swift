//
//  TextArea.swift
//  streamline
//
//  Created by Matt Forgacs on 5/25/21.
//

import SwiftUI

struct TextArea: View {
    @Binding var text: String

    let placeholder: String
    let horizontalPadding: CGFloat
    let font: Font
    var characterLimitEnabled = false
    let limitCompletedAction: (()-> Void)?
    
    init(_ placeholder: String, text: Binding<String>, horizontalPadding: CGFloat = 8, font: Font = .body, characterLimitEnabled: Bool = false, limitCompletedAction: (()-> Void)? = nil) {
        self._text = text
        self.placeholder = placeholder
        self.horizontalPadding = horizontalPadding
        self.font = font
        self.characterLimitEnabled = characterLimitEnabled
        self.limitCompletedAction = limitCompletedAction
        UITextView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(Color(.placeholderText))
                    .padding(.horizontal, horizontalPadding)
                    .padding(.vertical, 12)
            }
            
            TextEditor(text: $text)
//                .padding(4)
                .padding(.horizontal, horizontalPadding)
                .onChange(of: text) { newValue in
                    if characterLimitEnabled {
                        if self.text.count > 120 {
                            
                            let (currentPostText, newPostText) = getCurrentAndNextPostText(from: newValue)
                            self.text = currentPostText
                            limitCompletedAction?()

                            DispatchQueue.main.async {
                                // Add next text to new post
                                self.text = newPostText
                                print(self.text)
                            }
                        }
                    }
                }
        } .font(font)
    }
}
