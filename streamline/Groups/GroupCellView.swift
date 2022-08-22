//
//  GroupCellView.swift
//  streamline
//
//  Created by Tayyab Ali on 27/01/2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct GroupCellView: View {
    @Binding var group: Group
    var isSelected: Bool

    var body: some View {
        VStack {
            AnimatedImage(url: URL(string: group.imageURL ?? ""))
                .indicator(SDWebImageActivityIndicator.grayLarge)
                .resizable()
                .scaledToFill()
                .frame(width: 56, height: 56)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(Color.orange, lineWidth: isSelected ? 2 : 0)
                )

            Text(group.name)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(isSelected ? .orange : Color("AdaptiveColor"))
        }
    }
}

struct GroupCellView_Previews: PreviewProvider {
    static var previews: some View {
        GroupCellView(group: .constant(Group()), isSelected: false)
    }
}
