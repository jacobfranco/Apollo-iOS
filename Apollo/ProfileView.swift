//
//  ProfileView.swift
//  apollo
//
//  Created by Jacob Franco on 6/9/23.
//

import SwiftUI

struct ProfileView: View {
    
    var username: String?
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var followerViewModel: FollowerViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                Background()
                    .ignoresSafeArea(.all)
                
                VStack {
                    
                    ProfileTopView()
                        .padding(.top, 5)
                        .padding(.leading, 15)
                    
                    Spacer()
                    
                    ProfileBottomView()
                    
                    Spacer()
                } // END VSTACK
                .onAppear {
                    if let user = username {
                        // Fetch the profile for the username
                        userViewModel.fetchProfile(byUsername: user) { success in
                            // handle success or failure here, if needed
                        }
                    } else {
                        // Use the currently logged-in user profile
                        userViewModel.displayedUserProfile = userViewModel.loggedInUserProfile
                    }
                }
                .modifier(Title(title: userViewModel.displayedUserProfile.username))
                .navigationBarItems(trailing: NavigationLink(destination: SettingsView()) {
                    Image(systemName: "gear")
                        .foregroundColor(Color("Scheme-Inverse"))
                })
                .navigationBarTransparentBackground()
            } // END ZSTACK
        } // END NAVIGATIONVIEW
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        let fakeUserProfile = UserProfile(username: "TestUser42", displayName: "Test User", picture: "avi", bio: "This is a test user.  I love Apollo.")

        let fakeFollowers = [UserProfile(username: "follower1", displayName: "Follower 1", picture: "avi", bio: "I'm a fake follower."),
                             UserProfile(username: "follower2", displayName: "Follower 2", picture: "avi", bio: "I'm another fake follower.")]

        let fakeFollowing = [UserProfile(username: "following1", displayName: "Following 1", picture: "avi", bio: "I'm a fake following."),
                             UserProfile(username: "following2", displayName: "Following 2", picture: "avi", bio: "I'm another fake following.")]

        let userViewModel = UserViewModel()
        userViewModel.displayedUserProfile = fakeUserProfile
        userViewModel.loggedInUserProfile = fakeUserProfile

        let followerViewModel = FollowerViewModel()
        followerViewModel.followers = fakeFollowers
        followerViewModel.followingUsers = fakeFollowing

        return ProfileView()
            .environmentObject(userViewModel)
            .environmentObject(followerViewModel)
    }
}

