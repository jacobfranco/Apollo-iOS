//
//  ProfileTopView.swift
//  Apollo_Development
//
//  Created by Jacob Franco on 6/21/23.
//

import SwiftUI

struct ProfileTopView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var followerViewModel: FollowerViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            //First layer - Picture, Display name, and Bio
            HStack {
                UserImage(urlString: userViewModel.displayedUserProfile.picture)
                
                // VStack of Display Name and Bio
                VStack(alignment: .leading) {
                    
                    Text(userViewModel.displayedUserProfile.displayName)
                        .font(.custom("URWDIN-Bold", size: 12))
                        .padding(.top, 2)
                    Spacer()
                    Text(userViewModel.displayedUserProfile.bio)
                        .font(.custom("URWDIN-Regular", size: 12))
                        .lineLimit(nil)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 2)
                    
                    Spacer()
                    Spacer()
                }
            }
            .frame(height: 75)
            
            //2nd layer - Followers and Following Metrics + Social Links
            HStack {
                HStack {
                    NavigationLink(destination: UserListView(users: followerViewModel.followingUsers)) {
                                            Text("\(followerViewModel.followingUsers.count) Following")
                                                .font(.custom("URWDIN-Regular", size: 12))
                                        }
                    
                    NavigationLink(destination: UserListView(users: followerViewModel.followers)) {
                        Text("\(followerViewModel.followers.count) Followers")
                            .font(.custom("URWDIN-Regular", size: 12))
                    }
                }
                
            }
            .padding(.top, 5)
            .padding(.bottom, 15)
            
            //3rd layer - Edit Profile/Follow Button and Options Menu
            HStack {
                if userViewModel.isCurrentUser() {
                                            Button(action: {
                                                // Action for the EditProfile button
                                            }) {
                                                ZStack {
                                                    RoundedRectangle(cornerRadius: 5)
                                                        .foregroundColor(Color(UIColor.systemBackground).opacity(0.75))
                                                        .frame(width: 300, height: 30, alignment: .center)
                                                    
                                                    Text("EDIT PROFILE")
                                                        .font(.custom("URWDIN-Regular", size: 12))
                                                        .foregroundColor(Color("Scheme-Inverse"))
                                                }
                                            }
                                        } else {
                                            Button(action: {
                                                followerViewModel.toggleFollowStatus(loggedInUsername: userViewModel.loggedInUserProfile.username, displayedUsername: userViewModel.displayedUserProfile.username)
                                                }
                                            ) {
                                                ZStack {
                                                    RoundedRectangle(cornerRadius: 5)
                                                        .foregroundColor(Color(UIColor.systemBackground).opacity(0.75))
                                                        .frame(width: 300, height: 30, alignment: .center)
                                                    
                                                    Text(followerViewModel.isFollowingProfileUser ? "Unfollow" : "Follow")
                                                        .font(.custom("URWDIN-Regular", size: 12))
                                                        .foregroundColor(Color("Scheme-Inverse"))
                                                }
                
                                            }
                                        }
                
                Button(action: {
                    // Action for the SquareButton
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 5)
                            .foregroundColor(Color(UIColor.systemBackground).opacity(0.75))
                            .frame(width: 30, height: 30, alignment: .center)
                        
                        Image(systemName: "arrowshape.turn.up.right")
                            .font(.system(size: 12))
                            .foregroundColor(Color("Scheme-Inverse"))
                    }
                }
            } // END HStack
            .padding(.bottom, 5)
            
            //4th layer - Tags
            HStack {
                Text("Tags")
            }
        }
    }
}

struct ProfileTopView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Rectangle()
                .foregroundColor(Color.gray)
            ProfileTopView()
                .environmentObject( UserViewModel())
        }
    }
}
