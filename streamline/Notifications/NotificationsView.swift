//
//  NotificationsView.swift
//  streamline
//
//  Created by Matt Forgacs on 9/20/21.
//

import SwiftUI

struct NotificationsView: View {
    @ObservedObject var viewModel = NotificationViewModel()
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.notifications) { notification in
                    NotificationCell(notification: notification) {
                        if notification.type == .invite {
                            guard let groupId = notification.groupId else {
                                return
                            }
                            viewModel.joinGroup(groupId: groupId)
                        }
                    }
                }
            }
            .padding()
        }
        .toast(isPresenting: $viewModel.isLoading, alert: {
            .init(type: .loading)
        })
        .toast(isPresenting: $viewModel.showToast, duration: 1, tapToDismiss: true, alert: {
            viewModel.alertToast
        })
    }
}

struct NotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsView()
    }
}
