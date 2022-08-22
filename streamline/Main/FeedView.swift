//
//  FeedView.swift
//  streamline
//
//  Created by Matt Forgacs on 5/23/21.
//

import SwiftUI

//struct FeedView: View {
//    @State var  isShowingNewPostView = false
//    @ObservedObject var viewModel: FeedViewModel
//    @State var selectedFilter: NotesFilterOptions = .groupnotes

struct FeedView: View {
    @State var isShowingNewPostView = false
    @State var isShowingInviteUsersView = false
    @ObservedObject var viewModel: FeedViewModel
    @ObservedObject var myGroupViewModel: GetGroupViewModel
    @State private var selectedSegment = 0
//    @State private var showingPostOptions = false
    @State private var hasSelectedPostWithImage = false

    init(viewModel: FeedViewModel, myGroupViewModel: GetGroupViewModel) {
        self.viewModel = viewModel
        self.myGroupViewModel = myGroupViewModel
        self.viewModel.subscribeForPushNotification()
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            
            VStack {
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
                
                if selectedSegment == 1 && !myGroupViewModel.myGroups.isEmpty {
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
                    }
                }
                
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
                Spacer()
            }
            
            HStack {
                if selectedSegment == 1 && myGroupViewModel.myGroup != nil {
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
                }
                
                Spacer()
                
                if selectedSegment == 0 || !myGroupViewModel.myGroups.isEmpty {
                    
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
//                        .confirmationDialog("How you want to publish post?", isPresented: $showingPostOptions, titleVisibility: .visible) {
//                            Button("Post With Text") {
//                                hasSelectedPostWithImage = false
//                                isShowingNewPostView.toggle()
//                            }
//
//                            Button("Post With Image") {
//                                hasSelectedPostWithImage = true
//                                isShowingNewPostView.toggle()
//                            }
//                        }

                }
            }
        }
        .fullScreenCover(isPresented: $viewModel.showingCreateGroup) {
            CreateGroupView(isPresented: $viewModel.showingCreateGroup, viewModel: CreateGroupViewModel(myGroupViewModel: myGroupViewModel))
        }
//        .onAppear {
//            if selectedSegment == 1 {
//                viewModel.filterGroups(with: selectedGroupId)
//            }
//        }
    }
}

