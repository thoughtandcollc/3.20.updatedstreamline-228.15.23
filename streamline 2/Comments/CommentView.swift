//
//  CommentView.swift
//  streamline
//
//  Created by Matt Forgacs on 9/29/21.
//

import SwiftUI
import Kingfisher

struct CommentView: View {
    let reading: Reading
    @State var commentTxt: String = ""
    @State var showSubTextField = false
    @State var height: CGFloat = 0
    @Binding var clickedOut: Bool
    @State var clickedOnMe: Bool = false
    
//        .onAppear {
//            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { (noti) in
//                let value = noti.userInfo! [UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
//                self.height = value.height
//                self.clickedOut = false
//            }
//
//            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { (noti) in
//                self.height = 0
//                self.showSubTextField = false
//            }
//    }

    let placeholder = "Add a Comment"

    func emojiButton(emoji: String) -> Button<Text> {
        Button {   if self.showSubTextField == false {
            self.showSubTextField = true
        }
        self.commentTxt += emoji
        } label: {
            Text(emoji)
        }
    }
    
    var body: some View {
        ZStack {
            HStack {
                Button(action: {
                    self.showSubTextField.toggle()
                }, label: {
                    Image(systemName: "message")
                        .font(.system(size: 16))
                        .frame(width: 32, height: 32)
                        .foregroundColor(.gray)
                })
//                TextField("Add a comment", text: $commentTxt, onEditingChanged: { _ in
//                    if self.clickedOut == true {
//                        self.clickedOut = false
//                    }
//                    self.showSubTextField = true
//
//                })
//                    .overlay(RoundedRectangle(cornerRadius: 5)
//                    .stroke(Color.orange, lineWidth: 0.1))
//
//                emojiButton(emoji: "🙌")
//            }
            .onTapGesture {
              if self.clickedOnMe == false {
                  self.clickedOnMe = true
              }
          }

            
            if self.showSubTextField == true {
                VStack {
                    HStack(spacing: 10) {
                        emojiButton(emoji: "🙌")
                        emojiButton(emoji: "😁")
                        emojiButton(emoji: "🔥")

                }
                    .font(.system(size: 15))
//                    .padding()
                    HStack {
                        KFImage(URL(string: reading.profileImageUrl))
                            .resizable()
                            .scaledToFill()
                            .clipped()
                            .frame(width: 20, height: 20)
                            .cornerRadius(10)
                    
                        HStack {
                            SOCustomTextField(text: $commentTxt, isFirstResponder: self.showSubTextField)
                            
                            Button(action: {
                                
                            }, label: {
                                Text("Post")
                                    .foregroundColor(.orange)
                                    .font(.system(size: 14))
                                    .opacity(0.5)
                            })
                            .padding(.trailing, 10)
                        }
                        .frame(height: 35)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                        .stroke(Color("AdaptiveColor"), lineWidth: 0.25))
                    }
                    .frame(height: 50)
                    .padding(.leading, 4)
                    .padding(.trailing, 4)
                }
//                .background(Color("PrimaryColorInvert"))
                .offset(y:(-self.height / 2) - 12)
                .padding(.trailing, 15)
                .animation(.spring())

            }
            
        } 
        .onChange(of: self.clickedOut) { clickedOutNew in
            if clickedOutNew == true {
                self.showSubTextField = false
                }
            }
        }
    }
}
//struct CommentView_Previews: PreviewProvider {
//    static var previews: some View {
//        CommentView()
//    }
//}
