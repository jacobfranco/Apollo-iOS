//
//  ProfileBottomView.swift
//  Apollo_Development
//
//  Created by Jacob Franco on 7/3/23.
//

import SwiftUI

struct ProfileBottomView: View {
    
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var followerViewModel: FollowerViewModel
    
    var body: some View {
        VStack {
            
            Button("Follow/Unfollow") {
                // implement follow/unfollow logic here
                // for example:
                followerViewModel.followUser(username: userViewModel.displayedUserProfile.username) // or unfollow
            }
            .buttonStyle(SingleButton())
            .padding()
            
        }
        .padding()
                
       
    }
}
