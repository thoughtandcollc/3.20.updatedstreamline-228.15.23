//
//  NotificationsCell.swift
//  streamline
//
//  Created by Matt Forgacs on 9/20/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct NotificationCell: View {
    let notification: NotificationCellViewModel
    let action: () -> Void

    var body: some View {
        VStack {
            HStack {
                AnimatedImage(url: URL(string: notification.profileImageUrl))
                    .indicator(SDWebImageActivityIndicator.grayLarge)
                    .resizable()
                    .scaledToFill()
                    .clipped()
                    .frame(width: 36, height: 36)
                    .clipShape(Circle())
                
                HStack {
                    Text(notification.username)
                        .font(.system(size: 14, weight: .semibold)) +
                    Text(notification.type.notificationText)
                        .font(.system(size: 15))
                }
                .padding(.horizontal, 4)
                
                Spacer()
                
                if notification.type == .invite {
                    Button (action: action) {
                        Text(notification.isGroupJoined ? "Joined" : "Join")
                            .font(.system(size: 14))
                            .foregroundColor(notification.isGroupJoined ? .gray : .orange)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(notification.isGroupJoined ? .gray : .orange, lineWidth: 1)
                            )
                    }
                    .disabled(notification.isGroupJoined)
                }
                
//                if notification.type == .follow {
//                    Button(action: {}, label: {
//                        Text(notification.userIsFollowed ? "Following" : "Follow")
//                            .padding(.horizontal, 20)
//                            .padding(.vertical, 8)
//                            .background(Color(.systemBlue))
//                            .clipShape(Capsule())
//                            .foregroundColor(.white)
//                            .font(.system(size: 14, weight: .semibold))
//                    })
//                }
                
            }.padding(.horizontal, 4)
            
//            if let post = notification.post {
//                NotificationPostView(post: post)
//            }
//
            Divider()
        }
    }
}
