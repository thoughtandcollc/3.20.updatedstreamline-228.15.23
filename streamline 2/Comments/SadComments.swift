//
//  SadComments.swift
//  streamline
//
//  Created by Matt Forgacs on 10/1/21.
//

import SwiftUI
import Kingfisher
import Firebase

struct SadComments: View {
//    let reading: Reading
    @State var commentTxt: String = ""
    @State var showSubTextField = false
    @State private var usedNotes = [String]()
    @State private var rootNote = ""
    @State private var newNote = ""
    
    
func emojiButton(emoji: String) -> Button<Text> {
        Button {   if self.showSubTextField == false {
            self.showSubTextField = true
        }
        self.commentTxt += emoji
        } label: {
            Text(emoji)
        }
    }
    
    func addnewNote() {
//        let docRef = COLLECTION_ANNOTATE.document()

        let answer =
            newNote.lowercased()
            .trimmingCharacters(in: .whitespacesAndNewlines)
      
        guard answer.count > 0 else {
            return
        }
    
        usedNotes.append(answer)
        newNote = ""
        
//        docRef.setData(newNote) { _ in }
    }
    
    var body: some View {
        VStack (spacing: 12) {
            HStack(spacing: 10) {
                emojiButton(emoji: "🙌")
                emojiButton(emoji: "😁")
                emojiButton(emoji: "🔥")

        }
            .font(.system(size: 25))
//                    .padding()
            HStack {
                Image("logo")
                    .resizable()
                    .scaledToFill()
                    .clipped()
                    .frame(width: 20, height: 20)
                    .cornerRadius(10)
            
                HStack {
//                    SOCustomTextField(text: $commentTxt, isFirstResponder: self.showSubTextField)
                    TextField("Enter New Note", text: $newNote, onCommit: addnewNote)
                        .textContentType(.oneTimeCode)
                        .keyboardType(.default)
                    
                    Button(action: {
                        addnewNote()
                    }, label: {
                        Text("Send")
                            .foregroundColor(.orange)
                            .font(.system(size: 18))
                            .bold()
                    })
                    .padding(.trailing, 10)
                }
                .frame(height: 25)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                .stroke(Color("AdaptiveColor"), lineWidth: 0.25))
            }
//                    .frame(height: 50)
            .padding(.leading, 4)
            .padding(.trailing, 4)
            
            HStack{
                List(usedNotes, id: \.self) {
                    Text($0)
                        .bold()
                    }
                }
            }
        }
    }

//struct SadComments_Previews: PreviewProvider {
//    static var previews: some View {
//        SadComments()
//    }
//}
