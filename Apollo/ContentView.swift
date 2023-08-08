//
//  ContentView.swift
//  apollo
//
//  Created by Jacob Franco on 6/9/23.
//

import SwiftUI
import Auth0
import TabBar

struct ContentView: View {
    @State private var selection: TabItem = .first
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var postViewModel: PostViewModel
    @EnvironmentObject var followerViewModel: FollowerViewModel
    @EnvironmentObject var timelineViewModel: TimelineViewModel
    @State private var visibility: TabBarVisibility = .visible
    
    var body: some View {
        if userViewModel.authenticated && userViewModel.profileComplete {
            TabBar(selection: $selection, visibility: $visibility) {
                getTabItemView(for: TabItem.first)
                getTabItemView(for: TabItem.second)
                getTabItemView(for: TabItem.third)
                getTabItemView(for: TabItem.fourth)
            }
            .tabBar(style: CustomTabBarStyle())
            .tabItem(style: CustomTabItemStyle())
        } else if userViewModel.authenticated && !userViewModel.profileComplete {
            UpdateProfileView()
        } else {
            LandingPageView()
        }
    } // END BODY

    @ViewBuilder
    func getTabItemView(for tabItem: TabItem) -> some View {
        switch tabItem {
        case .first:
            HomeView()
                .tabItem(for: tabItem)
        case .second:
            SearchView()
                .tabItem(for: tabItem)
        case .third:
            FantasyView()
                .tabItem(for: tabItem)
        case .fourth:
            ProfileView()
                .tabItem(for: tabItem)
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .environmentObject(UserViewModel())
                .environmentObject(PostViewModel())
                .environmentObject(FollowerViewModel())
                .environmentObject(TimelineViewModel())
                .preferredColorScheme(.light)
                .previewDisplayName("Light Mode")
            
            ContentView()
                .environmentObject(UserViewModel())
                .environmentObject(PostViewModel())
                .environmentObject(FollowerViewModel())
                .environmentObject(TimelineViewModel())
                .preferredColorScheme(.dark)
                .previewDisplayName("Dark Mode")
        }
    }
}
