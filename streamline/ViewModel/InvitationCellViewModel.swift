//
//  InvitationCellViewModel.swift
//  streamline
//
//  Created by Tayyab Ali on 26/01/2022.
//

import Foundation

class InvitationCellViewModel: ObservableObject, Identifiable {
    var id: String
    var profileImageUrl: String
    var fullname: String
    var invitationSent: Bool = false
    var alreadyMember: Bool = false

    init(_ user: User, group: Group) {
        self.id = user.id
        self.profileImageUrl = user.profileImageUrl
        self.fullname = user.fullname
        self.alreadyMember = group.joinedUsers?.contains(user.id) ?? false
    }
}
