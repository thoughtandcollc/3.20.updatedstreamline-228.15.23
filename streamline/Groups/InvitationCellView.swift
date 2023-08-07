//
//  InvitationCellView.swift
//  streamline
//
//  Created by Tayyab Ali on 25/01/2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct InvitationCellView: View {
    let user: InvitationCellViewModel
    let action: () -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center, spacing: 12) {
                AnimatedImage(url: URL(string: user.profileImageUrl))
                    .indicator(SDWebImageActivityIndicator.grayLarge)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 56, height: 56)
                    .clipShape(Circle())
                
                HStack {
                    Text(user.fullname)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(Color("AdaptiveColor"))
                }
                
                Spacer()
                
                Button (action: action) {
                    Text(getButtonText())
                        .font(.system(size: 14))
                        .foregroundColor(user.invitationSent || user.alreadyMember ? .gray : .orange)
                        .padding(.vertical, 5)
                        .frame(width: 130)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(user.invitationSent || user.alreadyMember ? .gray : .orange, lineWidth: 1)
                        )
                }
                .disabled(user.invitationSent || user.alreadyMember)
            }
            Divider()
        }
        .padding([.leading, .trailing, .bottom])
    }
    
    func getButtonText() -> String {
        if user.alreadyMember {
            return "Already Member"
        }
        
        if user.invitationSent {
            return "Sent"
        }
        
        return "Invite"
    }
}

struct InvitationCellView_Previews: PreviewProvider {
    static var previews: some View {
        InvitationCellView(user: InvitationCellViewModel(User(dictionary: [:]), group: Group())) {}
    }
}
