//
//  NewMargin.swift
//  streamline
//
//  Created by Matt Forgacs on 10/7/21.
//

import SwiftUI
import Kingfisher

struct NewMargin: View {
    @Binding var isPresented: Bool
    @State var captionComment: String = ""
    @ObservedObject var viewModel: uploadMargin

    var reading: Reading?
    
    init(isPresented: Binding<Bool>) {
    self._isPresented = isPresented
    self.viewModel = uploadMargin(isPresented: isPresented)
    }

    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    if let user = AuthViewModel.shared.user {
                        KFImage(URL(string: user.profileImageUrl))
                            .resizable()
                            .scaledToFill()
                            .clipped()
                            .frame(width: 64, height: 64)
                            .cornerRadius(32)
                    }

                    HStack(alignment: .center) {
                        TextArea("Comment", text: $captionComment)
                    }
                    .padding()

                    Spacer()
                }

                .padding()

                .navigationBarItems(leading:
                                        Button(action: { isPresented.toggle()}, label: { Text("Cancel")
                                                .foregroundColor(Color("AdaptiveColor"))                                        }),
                trailing: Button(action: {
                        viewModel.uploadMargin(reply: captionComment)
                },

                label: {
                    Text("Comment")
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
