//
//  UserListItemView.swift
//  Apollo_Development
//
//  Created by Jacob Franco on 8/7/23.
//

import SwiftUI

struct UserListItemView: View {
    @EnvironmentObject var followerViewModel: FollowerViewModel
    var userProfile: UserProfile

    var body: some View {
        HStack {
            // Profile Picture
                           Image(userProfile.picture)
                           .resizable()
                           .aspectRatio(contentMode: .fill)
                           .frame(width: 50, height: 50)
                           .clipShape(RoundedRectangle(cornerRadius: 5))
            
            VStack(alignment: .leading) {
                // Display Name, Username, and Follow/Unfollow button
                HStack {
                    HStack {
                        // Display Name and Username
                        Text(userProfile.displayName)
                            .modifier(DisplayName())
                        Text(" | ")
                            .modifier(Pipe())
                        Text(userProfile.username)
                            .modifier(Username())
                    }
                    
                    Spacer()
                    
                    // Follow/Unfollow button
                    Button(action: {
                        // Perform follow/unfollow action
                        // This will need to be connected to an actual function in your view model
                        self.followerViewModel.isFollowingProfileUser.toggle()
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 5)
                                .foregroundColor(Color(UIColor.systemBackground).opacity(0.75))
                                .frame(width: 100, height: 30, alignment: .center)

                            Text(followerViewModel.isFollowingProfileUser ? "Unfollow" : "Follow")
                                .font(.custom("URWDIN-Regular", size: 12))
                                .foregroundColor(Color("Scheme-Inverse"))
                        }
                    }
                }
                
                // Bio
                Text(userProfile.bio)
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .lineLimit(nil)
            }
            .padding(5)
        }
        .padding(5)
    }
}


struct UserListItemView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Rectangle()
                .foregroundColor(Color.black)
            UserListItemView(userProfile: UserProfile(username: "testUser", displayName: "Test User", picture: "avi", bio: "This is a test bio for a test user."))
                .environmentObject(FollowerViewModel())
                .previewLayout(.sizeThatFits)
        }
        
    }
}



