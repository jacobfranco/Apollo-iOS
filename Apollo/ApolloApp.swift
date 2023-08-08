//
//  ApolloApp.swift
//  Apollo
//
//  Created by Jacob Franco on 8/8/23.
//

import SwiftUI

@main
struct ApolloApp: App {
    @StateObject private var userViewModel = UserViewModel()
    @StateObject private var followerViewModel = FollowerViewModel()
    @StateObject private var postViewModel = PostViewModel()
    @StateObject private var timelineViewModel = TimelineViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(userViewModel)
                .environmentObject(followerViewModel)
                .environmentObject(postViewModel)
                .environmentObject(timelineViewModel)
        }
    }
}
