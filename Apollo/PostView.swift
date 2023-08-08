//
//  PostView.swift
//  Apollo_Development
//
//  Created by Jacob Franco on 7/10/23.
//

import SwiftUI

struct PostView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var postViewModel: PostViewModel
    @EnvironmentObject var followerViewModel: FollowerViewModel
    let post: Post
    

    var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .top, spacing: 10) {
                // First VStack for Profile Picture
                VStack(alignment: .leading) {
                    NavigationLink(destination: ProfileView(username: post.author.username)) {
                            Image(post.author.picture)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 50, height: 50)
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                                .padding([.leading, .top], 8)
                        }
                }

                // Second VStack containing 3 HStacks
                VStack(alignment: .leading, spacing: 8) {
                    // First HStack for Display name, Username, Timestamp, and Ellipsis
                    HStack {
                        // Display Name and Username
                        Text(post.author.displayName)
                            .modifier(DisplayName())
                        Text(" | ")
                            .modifier(Pipe())
                        Text(post.author.username)
                            .modifier(Username())
                        Spacer() // Pushes the timestamp and ellipsis to the end
                        Text(formattedTimeElapsed(since: post.created_at)) // Placeholder for timestamp
                            .modifier(Detail())
                        Menu {
                                        if isCurrentUserPost {
                                            // Options for the post owner
                                            Button(action: {
                                                postViewModel.deletePost(byId: post.id)
                                            }) {
                                                Text("Delete Post")
                                            }
                                        } else {
                                            // Options for other users
                                            if followerViewModel.followingUsers.contains(where: { $0.username == post.author.username })  {
                                                        // Option to unfollow the post author
                                                        Button(action: {
                                                            followerViewModel.unfollowUser(username: post.author.username)
                                                        }) {
                                                            Text("Unfollow \(post.author.username)")
                                                        }
                                                    } else {
                                                        // Option to follow the post author
                                                        Button(action: {
                                                            followerViewModel.followUser(username: post.author.username)
                                                        }) {
                                                            Text("Follow \(post.author.username)")
                                                        }
                                                    }

                                            Button(action: {
                                                // Action to mute the user
                                            }) {
                                                Text("Mute")
                                            }

                                            Button(action: {
                                                // Action to block the user
                                            }) {
                                                Text("Block")
                                            }

                                            Button(action: {
                                                // Action to report the post/user
                                            }) {
                                                Text("Report")
                                            }
                                        }
                                    } label: {
                                        Image(systemName: "ellipsis")
                                    }
                                    .modifier(IconStyle())

                    }
                    .padding(.top, 8)

                    // Second HStack for Post Body
                    HStack {
                        Text(post.body)
                            .modifier(h5())
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                        Spacer() // Ensures the post body fills as much space as possible
                    }
                    .padding(.bottom, 8)

                    // Third HStack for Social Metrics and Share button
                    HStack {
                        // Social Metrics
                        Spacer() // Pushes Metrics to Middle
                        HStack(spacing: 10) {
                            Button(action: {}) {
                                HStack {
                                    Image(systemName: "bubble.right")
                                    Text("123") // Placeholder for comment count
                                }
                                .modifier(MetricStyle())
                            }.padding(.trailing, 8)
                            
                            
                            Button(action: {}) {
                                HStack {
                                    Image(systemName: "heart")
                                    Text("456") // Placeholder for like count
                                }
                                .modifier(MetricStyle())
                            }.padding(.leading, 8)
                        }
                        Spacer() // Pushes the share button to the end
                        Spacer() // Pushes Metrics to Middle
                        Button(action: {}) {
                            Image(systemName: "square.and.arrow.up")
                        }
                        .modifier(IconStyle())
                    }
                }
                .padding([.trailing, .bottom], 8)
            }
        }
        
        .background(VisualEffectView(effect: UIBlurEffect(style: .systemThickMaterial))
            .opacity(0.1)
            .ignoresSafeArea(.all))
        .frame(maxWidth: .infinity)
        
        .overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color.gray, lineWidth: 0.5).opacity(0.5)
        )
        
        
    }
    
    var isCurrentUserPost: Bool {
           userViewModel.loggedInUserProfile.username == post.author.username
       }
}



struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView( post: Post(id: "0", author: UserProfile(username: "jfranco70428234", displayName: "Jacob Franco DA GOAT CEO", picture: "avi", bio: "Hello"), body: "Hello my name is Jacob Franco.  This is a Test post on Apollo.", created_at: "2023-07-27T12:34:56Z"))
            .environmentObject(UserViewModel())
            .environmentObject(PostViewModel())
            .environmentObject(FollowerViewModel())
            .preferredColorScheme(.dark)
            .previewDisplayName("Dark Mode")
    }
}
