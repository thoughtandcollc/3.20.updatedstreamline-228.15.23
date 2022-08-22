//
//  UsersListView.swift
//  streamline
//
//  Created by Tayyab Ali on 25/01/2022.
//

import SwiftUI

struct UsersListView: View {
    @ObservedObject var viewModel: InvitationUsersListViewModel
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.users) { user in
                        InvitationCellView(user: user) {
                            viewModel.inviteUser(toUid: user.id) {
                                user.invitationSent = true
                            }
                        }
                    }
                }
                .padding(.vertical)
            }
            .onAppear {
                viewModel.fetchUsers()
            }
            .toast(isPresenting: $viewModel.isLoading, alert: {
                .init(type: .loading)
            })
            .toast(isPresenting: $viewModel.showToast, duration: 1, tapToDismiss: true, alert: {
                viewModel.alertToast
            })
            .navigationTitle("Invite")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading:
                                    Button(action: {
                isPresented.toggle()
            }, label: {
                Text("Cancel")
                    .foregroundColor(Color("AdaptiveColor"))
            }))
        }
    }
}

struct UsersListView_Previews: PreviewProvider {
    static var previews: some View {
        UsersListView(viewModel: .init(myGroup: Group()), isPresented: .constant(true))
    }
}
