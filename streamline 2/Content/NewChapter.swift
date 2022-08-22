//
//  NewChapter.swift
//  streamline
//
//  Created by Matt Forgacs on 9/25/21.
//

import SwiftUI
import Kingfisher

struct NewChapter: View {
    @Binding var isPresented: Bool
    @State var captionText: String = ""
    @ObservedObject var viewModel: UploadChapterViewModel
    
    var reading: Reading?
    
    init(isPresented: Binding<Bool>) {
        self._isPresented = isPresented
       self.viewModel = UploadChapterViewModel(isPresented: isPresented)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                HStack(alignment: .top) {
                    if let user = AuthViewModel.shared.user {
                        KFImage(URL(string: user.profileImageUrl))
                            .resizable()
                            .scaledToFill()
                            .clipped()
                            .frame(width: 64, height: 64)
                            .cornerRadius(32)
                    }
                   
                    TextArea("Chapter boi", text: $captionText)
                    
                    Spacer()
                }
                
                .padding()
                
                .navigationBarItems(leading:
                                        Button(action: { isPresented.toggle()}, label: { Text("Cancel")
                                .foregroundColor(.black)
                                        }
                                        ),
                trailing: Button(action: {
                    viewModel.uploadChapter(caption: captionText)
                },
                
               label: {
                    Text("Almost There Bro")
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                }))
                        Spacer()
            

            }
        }
    }
}
