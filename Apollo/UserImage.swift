//
//  UserImage.swift
//  apollo
//
//  Created by Jacob Franco on 6/9/23.
//

import SwiftUI

struct UserImage: View {
    var urlString: String
    var body: some View {
        AsyncImage(url: URL(string: urlString)) { image in
            image
                .resizable()
                .frame(width: 75, height: 75)
                .cornerRadius(5)
                .border(Color.gray.opacity(0.5), width: 0.5)
        } placeholder: {
            Image("avi")
                .resizable()
                .frame(width: 75, height: 75)
                .cornerRadius(5)
                .border(Color.gray.opacity(0.5), width: 0.5)
        }
    }
}

struct UserImage_Previews: PreviewProvider {
    static var previews: some View {
        UserImage(urlString: "test")
    }
}
