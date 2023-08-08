//
//  HomeView.swift
//  apollo
//
//  Created by Jacob Franco on 6/9/23.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var postViewModel: PostViewModel
    @EnvironmentObject var timelineViewModel: TimelineViewModel
    
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        NavigationView {
            ZStack {
                Background()
                    .ignoresSafeArea(.all)

                VStack {
                    ScrollView {
                        TimelineView()
                    }
                    .padding(.top, 5)
                }
                .modifier(Title(title: "APOLLO"))
                .navigationBarItems(trailing: NavigationLink(destination: MessagesView()) {
                    Image(systemName: "message")
                        .foregroundColor(Color("Scheme-Inverse"))
                })
                
                
                // Create Post Button
                                NavigationLink(destination: CreatePostView().environmentObject(postViewModel).environmentObject(userViewModel)) {
                                    
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 5)
                                            .frame(width: 50, height: 50)
                                            .foregroundColor(Color("Primary"))
                                            .shadow(radius: 10)
                                            .padding()
                                        
                                        Image(systemName: "plus")
                                                    .foregroundColor(Color("Scheme-Inverse"))
                                    }
                                }
                                .position(x: UIScreen.main.bounds.width - 50, y: UIScreen.main.bounds.height - 225)
            } // END ZSTACK
        }
    }
}



struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HomeView()
                .environmentObject(UserViewModel())
                .environmentObject(PostViewModel())
                .environmentObject(FollowerViewModel())
                .environmentObject(TimelineViewModel())
                .preferredColorScheme(.light)
                .previewDisplayName("Light Mode")
            
            HomeView()
                .environmentObject(UserViewModel())
                .environmentObject(PostViewModel())
                .environmentObject(FollowerViewModel())
                .environmentObject(TimelineViewModel())
                .preferredColorScheme(.dark)
                .previewDisplayName("Dark Mode")
        }
    }
}
