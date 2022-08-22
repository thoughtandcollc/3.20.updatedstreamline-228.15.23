//
//  NotificationCellViewModel.swift
//  streamline
//
//  Created by Tayyab Ali on 26/01/2022.
//

import Foundation

class NotificationCellViewModel: ObservableObject, Identifiable {
    var id: String
    var profileImageUrl: String
    var username: String
    var type: NotificationType
    var groupId: String?
    var groupName: String
    var isGroupJoined: Bool
    
    init(_ notification: AppNotification) {
        let joinedGroups = AuthViewModel.shared.user?.joinedGroups ?? []
        self.id = notification.id
        self.profileImageUrl = notification.profileImageUrl
        self.username = notification.username
        self.type = notification.type
        self.groupId = notification.groupId
        self.groupName = notification.groupName ?? ""
        self.isGroupJoined = joinedGroups.contains(notification.groupId ?? "")
    }
}
