//
//  ReplyUploadView.swift
//  streamline
//
//  Created by Matt Forgacs on 8/1/21.
//

//import SwiftUI
//import Kingfisher
//
//struct NewReply: View {
//    @Binding var isPresented: Bool
//    @State var captionText: String = ""
//    @ObservedObject var viewModel: UploadReplyViewModel
//
//    var reply: Reply?
//
//    init(isPresented: Binding<Bool>) {
//        self._isPresented = isPresented
//        self.viewModel = UploadReplyViewModel(isPresented: isPresented)
//    }
//
//    var body: some View {
//        NavigationView {
//            VStack {
//                HStack(alignment: .top) {
//                    if let user = AuthViewModel.shared.user {
//                        KFImage(URL(string: user.profileImageUrl))
//                            .resizable()
//                            .scaledToFill()
//                            .clipped()
//                            .frame(width: 64, height: 64)
//                            .cornerRadius(32)
//                    }
//
//                    TextArea("Type your reply here...", text: $captionText)
//
//                    Spacer()
//                }
//
//                .padding()
//
//                .navigationBarItems(leading:
//                                        Button(action: { isPresented.toggle()}, label: { Text("Cancel")
//                                .foregroundColor(.black)
//                                        }),
//                trailing: Button(action: {
//                    viewModel.uploadReply(caption: captionText)
//                },
//
//                label: {
//                    Text("Reply")
//                            .padding(.horizontal)
//                            .padding(.vertical, 8)
//                            .background(Color.orange)
//                            .foregroundColor(.white)
//                            .clipShape(Capsule())
//                }))
//                        Spacer()
//            }
//        }
//    }
//}
//
//struct NewReply_Previews: PreviewProvider {
//    static var previews: some View {
//        NewReply(isPresented: .constant(true))
//    }
//}
