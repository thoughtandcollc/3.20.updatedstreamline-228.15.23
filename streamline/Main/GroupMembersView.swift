//
//  GroupMembersView.swift
//  streamline
//
//  Created by Sibtain Ali (Fiverr) on 26/04/2023.
//

import SwiftUI

struct GroupMembersView: View {
    
    @StateObject var model: GroupMembersViewModel
    @State private var searchText = ""
    @State private var isSearching = false
    
    init(group: Group) {
        _model = StateObject(wrappedValue: GroupMembersViewModel(group: group))
    }
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                
                SearchBarView(searchText: $searchText, isSearching: $isSearching)
                    .padding(.top, 10)
                    .padding(.horizontal, 20)
                
                List {
                    ForEach(model.membersList.filter { searchText.isEmpty ? true : $0.fullname.localizedCaseInsensitiveContains(searchText) }) { member in
                        
                        HStack {
                            
                            Text(member.fullname)
                            
                            Spacer()
                            
                            Text("Owner")
                                .font(.system(size: 12))
                                .foregroundColor(.blue)
                                .padding(.horizontal, 4)
                                .padding(.vertical, 2)
                                .background{
                                    RoundedRectangle(cornerRadius: 4).stroke(Color.blue, lineWidth: 1)
                                }
                                .isVisible(model.group.createdBy == member.id)
                                
                            
                            // TODO: - change for admin settings
                            Text("Request ")
                                .font(.system(size: 12))
                                .foregroundColor(.orange)
                                .padding(.horizontal, 4)
                                .padding(.vertical, 2)
                                .background{
                                    RoundedRectangle(cornerRadius: 4).stroke(Color.orange, lineWidth: 1)
                                }
                                .isVisible(false)
                            
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            model.memberTapped(member: member)
                        }
                    }
                }
                .listStyle(InsetGroupedListStyle())
                .padding(.top, 10)
            }
            .navigationBarTitle("Search")
        }
    }
}



struct GroupMembersView_Previews: PreviewProvider {
    static var previews: some View {
        GroupMembersView(group: Group())
    }
}
