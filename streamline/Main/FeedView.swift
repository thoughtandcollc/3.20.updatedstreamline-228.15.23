//
//  FeedView.swift
//  streamline
//
//  Created by Matt Forgacs on 5/23/21.
//

import SwiftUI

struct FeedView: View {
    
    @ObservedObject var viewModel        : FeedViewModel
    @ObservedObject var myGroupViewModel : GetGroupViewModel
    
    @State private var isShowingNewPostView     = false
    @State private var isShowingInviteUsersView = false
    
    @State private var selectedSegment          = 0
    @State private var hasSelectedPostWithImage = false

    init(viewModel: FeedViewModel, myGroupViewModel: GetGroupViewModel) {
        self.viewModel = viewModel
        self.myGroupViewModel = myGroupViewModel
        self.viewModel.subscribeForPushNotification()
    }
    
    var body: some View {
        
        ZStack(alignment: .bottom) {
            
            VStack {
         
                TopPickerView()
                
                GroupsHorizontalListView()
                
                MainListView()
                
                Spacer()
                
            }
            
            HStack {
                
                ShareButtonView()
                
                Spacer()
                
                TweetButtonView()
                
            }
        }
        .fullScreenCover(isPresented: $viewModel.showingCreateGroup) {
            CreateGroupView(isPresented: $viewModel.showingCreateGroup, viewModel: CreateGroupViewModel(myGroupViewModel: myGroupViewModel))
        }
        .sheet(isPresented: $viewModel.showGroupSearchView) {
            SearchGroupView()
        }
    }
    
}

// MARK: - View Functions
// MARK: -
extension FeedView {
    
    private func TopPickerView() -> some View {
        
        Picker("", selection: $selectedSegment) {
            Text("Global")
                .tag(0)
            Text("Groups")
                .tag(1)
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding(16)
        .scaleEffect(CGSize(width: 1, height: 1.2))
        .onAppear {
            UISegmentedControl.appearance().selectedSegmentTintColor = .systemOrange
            UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
            UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.systemOrange], for: .normal)
        }
        .onTapGesture {
            self.selectedSegment = selectedSegment == 0 ? 1 : 0
            
            if selectedSegment == 1 {
                viewModel.selectedGroupId = viewModel.selectedGroupId.isEmpty ? myGroupViewModel.myGroups.first?.id ?? "" : viewModel.selectedGroupId
            }
        }
        
    }
    
    private func GroupsHorizontalListView() -> some View {
        
        VStack {
            
            RequestsView()
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack {
                    ForEach($myGroupViewModel.myGroups) { group in
                        GroupCellView(group: group, isSelected: group.id == viewModel.selectedGroupId)
                            .frame(width: 100)
                            .onTapGesture {
                                viewModel.selectedGroupId = group.id
                            }
                    }
                }
                .frame(height: 100)
                .padding(.horizontal)
                
                Divider()
                
            }
        }
        .isVisible(selectedSegment == 1 && !myGroupViewModel.myGroups.isEmpty)
        
    }
    
    private func RequestsView() -> some View {
        
        HStack {
            Text("Join Requests")
            Spacer()
            Text("\(myGroupViewModel.myGroup?.joinRequests?.count ?? 0)")
        }
        .foregroundColor(.blue)
        .padding(.horizontal)
        .contentShape(Rectangle())
        .onTapGesture {
            viewModel.showGroupJoinRequestsView.toggle()
        }
        .sheet(isPresented: $viewModel.showGroupJoinRequestsView) {
            GroupJoinRequestsView(group: myGroupViewModel.myGroup ?? Group())
        }
        .isVisible(myGroupViewModel.myGroup?.joinRequests?.count ?? 0 > 0)
        
    }
    
    private func MainListView() -> some View {
        
        ScrollView {
            LazyVStack {
                ForEach(Array(selectedSegment == 0 ? viewModel.feedPosts.keys : viewModel.filteredGroupPosts.keys).sorted(by: >), id: \.self) { key in
                    let posts = selectedSegment == 0 ? viewModel.feedPosts : viewModel.filteredGroupPosts
                    NavigationLink(destination: PostDetailView(post: posts[key]!.first!)) {
                        PostCell(posts: posts[key]!)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding()
                
                // Bottom Edge inset
                Color.clear.padding(.bottom, 30)

            } .padding()
        }
        
    }
    
    private func ShareButtonView() -> some View {
        
        Button(action: {
            isShowingInviteUsersView.toggle()
        }, label: {
            Image(systemName: "square.and.arrow.up")
                .font(Font.system(size: 20, weight: .semibold))
                .padding()
        })
        .background(Color(.systemOrange))
        .foregroundColor(.white)
        .clipShape(Circle())
        .padding()
        .fullScreenCover(isPresented: $isShowingInviteUsersView) {
            if let myGroup = myGroupViewModel.myGroup {
                UsersListView(viewModel: .init(myGroup: myGroup), isPresented: $isShowingInviteUsersView)
            }
        }
        .isVisible(selectedSegment == 1 && myGroupViewModel.myGroup != nil)
        
    }
    
    private func TweetButtonView() -> some View {
        
        Button(action: { isShowingNewPostView.toggle() }, label: {
            Image("Tweet")
                .resizable()
                .renderingMode(.template)
                .frame(width: 28, height: 28)
                .padding()
        })
        .background(Color(.systemOrange))
        .foregroundColor(.white)
        .clipShape(Circle())
        .padding()
        .fullScreenCover(isPresented: $isShowingNewPostView) {
            NewPost(isPresented: $isShowingNewPostView, groupId: selectedSegment == 0 ? "" : viewModel.selectedGroupId)
        }
        .isVisible(selectedSegment == 0 || !myGroupViewModel.myGroups.isEmpty )
        
    }
    
}



// MARK: - Preview
// MARK: -
struct FeedView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        FeedView(viewModel: FeedViewModel(), myGroupViewModel: GetGroupViewModel())
        
    }
}


