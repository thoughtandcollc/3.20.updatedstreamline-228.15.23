//
//  GroupJoinRequestsView.swift
//  streamline
//
//  Created by Sibtain Ali (Fiverr) on 19/03/2023.
//

import SwiftUI

struct GroupJoinRequestsView: View {
    
    @StateObject var model: JoinRequestViewModel
    
    var body: some View {
        
        VStack {
            
            List {
                ForEach(model.usersList) { user in
                    
                    Text(user.fullname)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            model.requestTapped(id: user.id, name: user.fullname)
                        }
                    
                }
            }
            .listStyle(InsetGroupedListStyle())
            .padding(.top, 10)
            
        }
        .navigationBarTitle("Requests")
        
    }
    
    init(group: Group) {
        _model =   StateObject(wrappedValue: JoinRequestViewModel(group: group))
    }
}

struct GroupJoinRequestsView_Previews: PreviewProvider {
    static var previews: some View {
        GroupJoinRequestsView(group: Group())
    }
}
