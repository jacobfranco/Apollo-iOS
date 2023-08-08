//
//  PostDetailView.swift
//  Apollo_Development
//
//  Created by Jacob Franco on 8/8/23.
//

import SwiftUI

struct PostDetailView: View {
    @EnvironmentObject var postViewModel: PostViewModel
    let postId: String
    
    var body: some View {
        VStack {
            if let post = postViewModel.post {
                Text(post.body)
                Text(post.author.username)
                Text("\(post.created_at)")
            } else {
                Text("Loading...")
            }
        }
        .onAppear {
            postViewModel.fetchPost(byId: postId)
        }
    }
}


struct PostDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PostDetailView(postId: "1")
            .environmentObject(PostViewModel())
    }
}
