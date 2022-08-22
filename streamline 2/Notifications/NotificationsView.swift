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
                    NotificationCell(notification: notification)
                }
            }.padding()
        }
    }
}

struct NotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsView()
    }
}
