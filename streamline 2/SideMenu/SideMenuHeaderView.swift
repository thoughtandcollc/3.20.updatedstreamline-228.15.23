//
//  SideMenuHeaderView.swift
//  streamline
//
//  Created by Matt Forgacs on 6/28/21.
//

import SwiftUI
import Kingfisher

struct SideMenuHeaderView: View {
    private let user = AuthViewModel.shared.user
    @Binding var show: Bool
    
    var body: some View {
        
        ZStack(alignment: .topTrailing) {
            Button(action: {
                withAnimation(.spring()){
                    self.show.toggle()
                }
            }) {
                Image(systemName: "xmark")
                    .font(.system(size: 24))
                    .scaledToFill()
                    .foregroundColor(Color("AdaptiveColor"))            .shadow(color: .gray, radius: 10, x: 0, y: 0)
            }.padding()
            
            VStack(alignment: .leading) {
                KFImage(URL(string: user?.profileImageUrl ?? ""))
                    .resizable()
                    .scaledToFill()
                    .clipped()
                    .frame(width: 56, height: 56)
                    .cornerRadius(28)
                
                Text(user?.fullname ?? "")
                    .font(.system(size: 16, weight: .semibold))
                
                Text("@\(user?.email ?? "")")
                    .foregroundColor(.gray)
                    .font(.system(size: 15))
                    .padding(.bottom)
                
                HStack(spacing: 12) {
                    HStack(spacing: 4) {
                        Text("\(user?.stats.following ?? 0)").bold()
                        Text("Following")
                            .foregroundColor(.gray)
                    }
                    
                    HStack(spacing: 4) {
                        Text("\(user?.stats.followers ?? 0)").bold()
                        Text("Followers")
                            .foregroundColor(.gray)
                    }
                    Spacer()
                }
                Spacer()
            }.padding()
        }
    }
}

struct SideMenuHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        SideMenuHeaderView(show: .constant(false))
    }
}
