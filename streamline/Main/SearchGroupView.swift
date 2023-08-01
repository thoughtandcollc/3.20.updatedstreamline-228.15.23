//
//  SearchGroupView.swift
//  streamline
//
//  Created by Sibtain Ali (Fiverr) on 17/03/2023.
//

import SwiftUI

struct SearchGroupView: View {
    
    @StateObject var model = SearchGroupViewModel()
    @State private var searchText = ""
    @State private var isSearching = false
    @State private var moveToDetailScreen = false
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBarView(searchText: $searchText, isSearching: $isSearching)
                    .padding(.top, 10)
                    .padding(.horizontal, 20)
                
                List {
                    ForEach(model.groupsList.filter { searchText.isEmpty ? true : $0.name.localizedCaseInsensitiveContains(searchText) }, id: \.self) { group in
                        
                        HStack {
                            
                            Text(group.name)
                            
                            Spacer()
                            
                            Text("Joined")
                                .font(.system(size: 12))
                                .foregroundColor(.blue)
                                .padding(.horizontal, 4)
                                .padding(.vertical, 2)
                                .background{
                                    RoundedRectangle(cornerRadius: 4).stroke(Color.blue, lineWidth: 1)
                                }
                                .isVisible(group.joinedUsers?.contains(userId) ?? false)
                            
                            Text("Request Sent")
                                .font(.system(size: 12))
                                .foregroundColor(.orange)
                                .padding(.horizontal, 4)
                                .padding(.vertical, 2)
                                .background{
                                    RoundedRectangle(cornerRadius: 4).stroke(Color.orange, lineWidth: 1)
                                }
                                .isVisible(group.joinRequests?.contains(userId) ?? false)
                            
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            model.selectedGroup = group
                            moveToDetailScreen.toggle()
                        }
                    }
                }
                .listStyle(InsetGroupedListStyle())
                .padding(.top, 10)
                .background(NavigationLinksView())
            }
            .navigationBarTitle("Search")
        }
    }
    
}

// MARK: - View Functions
// MARK: -
extension SearchGroupView {
    
    private func NavigationLinksView() -> some View {
        
        NavigationLink(destination: GroupDetailView(searchModel: model), isActive: $moveToDetailScreen) {
            EmptyView()
        }
        
    }
    
}

struct SearchBarView: View {
    @Binding var searchText: String
    @Binding var isSearching: Bool
    
    var body: some View {
        HStack {
            TextField("Search", text: $searchText)
                .padding(.leading, 20)
                .onChange(of: searchText) { _ in
                    isSearching = true
                }
            
            if isSearching {
                Button(action: {
                    searchText = ""
                    isSearching = false
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
                .padding(.trailing, 20)
            }
        }
        .frame(height: 40)
        .background(Color(.systemGray5))
        .cornerRadius(10)
        .padding(.horizontal)
    }
}


struct SearchGroupView_Previews: PreviewProvider {
    static var previews: some View {
        SearchGroupView()
    }
}
