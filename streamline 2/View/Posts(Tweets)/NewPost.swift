//
//  NewPost.swift
//  streamline
//
//  Created by Matt Forgacs on 5/25/21.
//
import SwiftUI
import Kingfisher

struct NewPost: View {
    @Binding var isPresented: Bool
    @State var captionText: String = ""
    @ObservedObject var viewModel: UploadPostViewModel

    var post: Post?

    init(isPresented: Binding<Bool>) {
        self._isPresented = isPresented
        self.viewModel = UploadPostViewModel(isPresented: isPresented)
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

                    TextArea("What are you thinking?", text: $captionText)

                    Spacer()
                }

                .padding()

                .navigationBarItems(leading:
                                        Button(action: { isPresented.toggle()}, label: { Text("Cancel")
                                                .foregroundColor(Color("AdaptiveColor"))                                        }),
                trailing: Button(action: {
                    viewModel.uploadPost(caption: captionText)
                },

                label: {
                    Text("Post")
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

struct NewPost_Previews: PreviewProvider {
    static var previews: some View {
        NewPost(isPresented: .constant(true))
    }
}
