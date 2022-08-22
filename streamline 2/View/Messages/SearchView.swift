//
//  SearchView.swift
//  streamline
//
//  Created by Matt Forgacs on 5/24/21.
//

import SwiftUI


struct SearchView: View {
    @State var searchtext = ""
    @ObservedObject var viewModel = SearchViewModel(config: .search)
    

    var body: some View {
        ScrollView{
        SearchBar(text: $searchtext)
            .padding()

            VStack(alignment: .leading) {
                ForEach(searchtext.isEmpty ? viewModel.users : viewModel.filteredUsers(searchtext)) { user in

                    HStack { Spacer() }

                    NavigationLink(
                        destination: LazyView(UserProfileView(user: user)),
                        label: {
                            Text("Bible Cell")
                        })
                }
            } .padding(.leading)
        }
    }
}
struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
