//
//  ConversationsView.swift
//  streamline
//
//  Created by Matt Forgacs on 5/24/21.
//

import SwiftUI

struct ConversationsView: View {
    @State var isShowingNewMessageView = false
    @State var showChat = false
    @State var user: User?
    @ObservedObject var viewModel = ConversationsViewModel()
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            
            if let user = user {
                NavigationLink(destination: LazyView(ChatView(user: user)),
                    isActive: $showChat,
                    label: {})
            }
            
            ScrollView {
                VStack {
                    ForEach(viewModel.recentMessages) { message in
                        NavigationLink(
                            destination: LazyView(ChatView(user: message.user)),
                            label: {
                                ConversationCell(message: message)
                           })
                    }
                }.padding()
            }
            
            HStack {
                Spacer()
                
            Button(action: { self.isShowingNewMessageView.toggle() }, label: {
                Image(systemName: "envelope")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
                    .padding()
                
            })
            .background(Color(.systemOrange))
            .foregroundColor(.white)
            .clipShape(Circle())
            .padding()
            .sheet(isPresented: $isShowingNewMessageView, content: {
                NewMessageView(show: $isShowingNewMessageView, startChat: $showChat, user: $user)
                })
            }
            .navigationTitle("Messages")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
struct ConversationsView_Previews: PreviewProvider {
    static var previews: some View {
        ConversationsView()
    }
}
