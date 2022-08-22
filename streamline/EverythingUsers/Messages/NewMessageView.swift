//
//  NewMessageView.swift
//  streamline
//
//  Created by Matt Forgacs on 5/25/21.
//

import SwiftUI

struct NewMessageView: View {
    @State var searchtext = ""
    @Binding var show: Bool
    @Binding var startChat: Bool
    @Binding var user: User?
    @ObservedObject var viewModel = SearchViewModel(config: .newMessage)
    
    var body: some View {
        ScrollView{
            SearchBar(text: $searchtext)
                .padding()
            
            VStack(alignment: .leading) {
                ForEach(searchtext.isEmpty ? viewModel.users : viewModel.filteredUsers(searchtext)) { user in
                    HStack { Spacer() }
                    
                    Button(action: {
                        self.show.toggle()
                        self.startChat.toggle()
                        self.user = user
                    }, label: {
                        UserCell(user: user)

                    })
                }
            } .padding(.leading)
        }
    }
}
