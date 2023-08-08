//
//  TimelineView.swift
//  Apollo_Development
//
//  Created by Jacob Franco on 6/15/23.
//

import SwiftUI

struct TimelineView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var timelineViewModel: TimelineViewModel
    @EnvironmentObject var postViewModel: PostViewModel

    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    ForEach(timelineViewModel.followingTimelinePosts, id: \.id) { post in
                        NavigationLink(destination: PostDetailView(postId: post.id)) {
                            PostView(post: post)
                        }
                    }
                }
                .onAppear {
                    // Here replace "username" and 1 with actual values
                    timelineViewModel.fetchFollowingTimeline(username: userViewModel.loggedInUserProfile.username, page: 1)
                }
            }
        }
    }
}



struct TimelineView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Rectangle()
                .foregroundColor(Color.black)
            TimelineView()
                .environmentObject(UserViewModel())
                .environmentObject(PostViewModel())
                .environmentObject(TimelineViewModel())
        }
        
    }
}
