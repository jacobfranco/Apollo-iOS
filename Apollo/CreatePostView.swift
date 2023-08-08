//
//  CreatePostView.swift
//  Apollo_Development
//
//  Created by Jacob Franco on 7/27/23.
//

import SwiftUI

struct CreatePostView: View {
    @State private var postContent = ""
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var postViewModel: PostViewModel
    @EnvironmentObject var userViewModel: UserViewModel

    var body: some View {
        VStack {
            HStack {
                Image(userViewModel.loggedInUserProfile.picture)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 25, height: 25)
                    .clipShape(Circle())
                TextField("Write your post here...", text: $postContent)
                    .padding()
            }
            Spacer()
        }
        .navigationBarTitle("New Post", displayMode: .inline)
        .navigationBarItems(
            leading: Button("Cancel") { presentationMode.wrappedValue.dismiss() },
            trailing: Button("Post") {
                postViewModel.createPost(content: postContent, userSub: userViewModel.loggedInAuthProfile.sub)
                presentationMode.wrappedValue.dismiss()
            }
        )
        .navigationBarBackButtonHidden(true)
        .onAppear {
            // Note: SwiftUI currently doesn't support automatic keyboard showing.
            // You will have to implement this manually using UIKit and UIViewRepresentable.
        }
    }
}





struct CreatePostView_Previews: PreviewProvider {
    static var previews: some View {
        CreatePostView()
            .environmentObject(UserViewModel())
            .environmentObject(PostViewModel())
    }
}
