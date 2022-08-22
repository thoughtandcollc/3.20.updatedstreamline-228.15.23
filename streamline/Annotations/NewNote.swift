//
//  SwiftUIView.swift
//  streamline
//
//  Created by Matt Forgacs on 9/3/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct NewNote: View {
    @Binding var isPresented: Bool
    @State var captionText: String = ""
    @ObservedObject var viewModel: uploadAnnotations

    var reading: Reading?
    
    init(isPresented: Binding<Bool>) {
    self._isPresented = isPresented
    self.viewModel = uploadAnnotations(isPresented: isPresented)
    }

    var body: some View {
        NavigationView {
            VStack {
                VStack {
//                    if let user = AuthViewModel.shared.user {
//                        AnimatedImage(url: URL(string: user.profileImageUrl))
//                            .indicator(SDWebImageActivityIndicator.grayLarge)
//                            .resizable()
//                            .scaledToFill()
//                            .clipped()
//                            .frame(width: 20, height: 20)
//                            .cornerRadius(4)
//                    }

                    HStack(alignment: .center) {
                        TextArea("Add New Annotation", text: $captionText)
                    }
                 //   .padding()

               //     Spacer()
                }

                .padding()

                .navigationBarItems(leading:
                                        Button(action: { isPresented.toggle()}, label: { Text("Cancel")
                                                .foregroundColor(Color("AdaptiveColor"))                                        }),
                trailing: Button(action: {
                        viewModel.uploadAnnotations(caption: captionText)
                },

                label: {
                    Text("Annotate")
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
