//
//  FeedView.swift
//  streamline
//
//  Created by Matt Forgacs on 5/23/21.
//

import SwiftUI

struct FeedView: View {
    
    @ObservedObject var feedModel  : FeedViewModel
    @ObservedObject var groupModel : GetGroupViewModel
    
    @State private var isShowingNewPostView     = false
    @State private var isShowingInviteUsersView = false
    
    @State private var selectedSegment          = 1
    @State private var hasSelectedPostWithImage = false
    
    @State private var selectedGroup: Group?

    init(viewModel: FeedViewModel, myGroupViewModel: GetGroupViewModel) {
        self.feedModel = viewModel
        self.groupModel = myGroupViewModel
        self.feedModel.subscribeForPushNotification()
    }
    
    var body: some View {
        
        ZStack(alignment: .bottom) {
            
            VStack {
         
               // TopPickerView()
                
               // GlobalPostsListView()
                
                GroupsView()
                
                Spacer()
                
            }
            
            HStack {
                
                ShareButtonView()
                
                Spacer()
                
                TweetButtonView()
                
            }
        }
        .overlay(content: {
            EmptyOverlayView()
        })
        .onAppear { updateSelectedGroup() }
        .onChange(of: feedModel.selectedGroupId) { _ in updateSelectedGroup() }
        .onChange(of: groupModel.joinedGroups, perform: { newValue in
            guard selectedGroup != nil else { updateSelectedGroup(); return }
            let selectedGrou = groupModel.joinedGroups.first(where: {$0.id == feedModel.selectedGroupId })
            self.selectedGroup = selectedGrou
        })
        .fullScreenCover(isPresented: $feedModel.showingCreateGroup) {
            CreateGroupView(group: nil)
        }
        .fullScreenCover(isPresented: $feedModel.showingEditGroup) {
            CreateGroupView(group: selectedGroup)
        }
        .sheet(isPresented: $feedModel.showingMembersView) {
            if selectedGroup != nil {
                GroupMembersView(group: selectedGroup!)
            }
            else {
                EmptyView()
            }
        }
        .sheet(isPresented: $feedModel.showGroupSearchView) {
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
                feedModel.selectedGroupId = selectedGroup?.id ?? groupModel.joinedGroups.first?.id ?? ""
            }
        }
        
    }
    
//    private func GlobalPostsListView() -> some View {
//        
//        ScrollView {
//            
//            LazyVStack {
//                
//                ForEach(Array(feedModel.feedPosts.keys).sorted(by: >), id: \.self) { key in
//                    NavigationLink(
//                        destination: PostDetailView(post: feedModel.feedPosts[key]!.first!)) {
//                        PostCell(posts: feedModel.feedPosts[key]!)
//                    }
//                    .buttonStyle(.plain)
//                }
//                .padding()
//                
//                // Bottom Edge inset
//                Color.clear.padding(.bottom, 30)
//
//            }
//            .padding()
//            
//        }
//        .isVisible(selectedSegment == 0)
//        .transition(.move(edge: .leading))
//        .animation(.linear(duration: 0.2), value: selectedSegment)
//        
//    }
    
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
        .opacity((selectedSegment == 1 && selectedGroup?.createdBy == userId) ? 1 : 0)
        .animation(.easeIn(duration: 0.2), value: selectedGroup)
        .fullScreenCover(isPresented: $isShowingInviteUsersView) {
            if let myGroup = selectedGroup {
                UsersListView(viewModel: .init(myGroup: myGroup), isPresented: $isShowingInviteUsersView)
            }
        }
        
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
            NewPost(isPresented: $isShowingNewPostView, groupId: selectedSegment == 0 ? "" : feedModel.selectedGroupId)
        }
        .isVisible(selectedSegment == 0 || groupModel.myGroups.isNotEmpty || groupModel.joinedGroups.isNotEmpty )
        
    }
    
    private func EmptyOverlayView() -> some View {
        
        VStack {
            
            Text("No groups yet? Use the search above...")
                .frame(maxWidth: .greatestFiniteMagnitude)
                .padding(.vertical, 4)
                .background(Color(.systemOrange))
            
            Divider().padding(.horizontal)
            
            
                
            
           Spacer()
        }
        .padding(.top)
        .isVisible(groupModel.myGroups.isEmpty && groupModel.joinedGroups.isEmpty && groupModel.areGroupsFetched)
        
    }
    
}

// MARK: - Groups View Functions
// MARK: -
extension FeedView {
    
    private func GroupsView() -> some View {
        
        VStack {
            
            RequestsView()
            
            GroupsHorizontalListView()
            
            EditGroupButtonView()
            
            NoPostsView().isVisible(groupModel.myGroups.isEmpty && groupModel.joinedGroups.isEmpty && groupModel.areGroupsFetched)
            
            GroupsPostsListView().isVisible(feedModel.filteredGroupPosts.isNotEmpty)
            
        }
        .padding(.top)

        
    }
    
    private func RequestsView() -> some View {
        
        HStack {
            Text("Join Requests")
            Spacer()
            Text("\(selectedGroup?.joinRequests?.count ?? 0)")
        }
        .foregroundColor(.blue)
        .padding(.horizontal)
        .contentShape(Rectangle())
        .onTapGesture {
            feedModel.showGroupJoinRequestsView.toggle()
        }
        .sheet(isPresented: $feedModel.showGroupJoinRequestsView) {
            GroupJoinRequestsView(group: selectedGroup ?? Group())
        }
        .isVisible(selectedGroup?.joinRequests?.count ?? 0 > 0)
        
    }

    private func GroupsHorizontalListView() -> some View {
        
        VStack {
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack {
                    ForEach($groupModel.joinedGroups) { group in
                        GroupCellView(group: group, isSelected: group.id == feedModel.selectedGroupId)
                            .frame(width: 100)
                            .onTapGesture {
                                feedModel.selectedGroupId = group.id
                            }
                    }
                }
                .frame(height: 100)
                .padding(.horizontal)
                
            }
            
        }
        //.isVisible(selectedSegment == 1 && !groupModel.joinedGroups.isEmpty)
        
    }
    
    private func EditGroupButtonView() -> some View {
        
        HStack {
            
            //--------------------------------------------------  Edit Group
            
            Button {
                feedModel.showingEditGroup.toggle()
            } label: {
                Text("Edit Group")
                    .font(.system(size: 12))
                    .foregroundColor(.white)
            }
            .tint(.blue)
            .buttonStyle(.borderedProminent)
            
            
            //-------------------------------------------------- Edit members
            
            Button {
                feedModel.showingMembersView.toggle()
            } label: {
                Text("Edit Members")
                    .font(.system(size: 12))
                    .foregroundColor(.white)
            }
            .tint(.blue)
            .buttonStyle(.borderedProminent)
            
            
        }
        .isVisible(isGroupOwner(memberId: userId, group: selectedGroup) || isGroupSubLeader(memberId: userId, group: selectedGroup))

        
    }
    
    private func GroupsPostsListView() -> some View {
        
        ScrollView {
            
            LazyVStack {
                
                ForEach(Array(feedModel.filteredGroupPosts.keys).sorted(by: >), id: \.self) { key in
                    NavigationLink(destination: PostDetailView(post: feedModel.filteredGroupPosts[key]!.first!)) {
                        PostCell(posts: feedModel.filteredGroupPosts[key]!)
                    }
                    .buttonStyle(.plain)
                }
                .padding()
                
                // Bottom Edge inset
                Color.clear.padding(.bottom, 30)

            }
            .padding()
        }
        
    }
    
}

// MARK: - Helper View Functions
// MARK: -
extension FeedView {
    
    private func updateSelectedGroup() {
        selectedGroup = groupModel.joinedGroups.first(where: {$0.id == feedModel.selectedGroupId }) ?? groupModel.joinedGroups.first
    }

}



// MARK: - Preview
// MARK: -
struct FeedView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        FeedView(viewModel: FeedViewModel(), myGroupViewModel: GetGroupViewModel())
        
    }
    
}










//private func MainListView() -> some View {
//
//    ScrollView {
//        LazyVStack {
//            ForEach(Array(selectedSegment == 0 ? feedModel.feedPosts.keys : feedModel.filteredGroupPosts.keys).sorted(by: >), id: \.self) { key in
//                let posts = selectedSegment == 0 ? feedModel.feedPosts : feedModel.filteredGroupPosts
//                NavigationLink(destination: PostDetailView(post: posts[key]!.first!)) {
//                    PostCell(posts: posts[key]!)
//                }
//                .buttonStyle(PlainButtonStyle())
//            }
//            .padding()
//
//            // Bottom Edge inset
//            Color.clear.padding(.bottom, 30)
//
//        } .padding()
//    }
//
//}
