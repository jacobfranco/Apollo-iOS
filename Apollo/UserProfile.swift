//
//  UserProfile.swift
//  Apollo_Development
//
//  Created by Jacob Franco on 7/10/23.
//

import Foundation

// UserProfile is a structure that is used to store the user profile data that is received from the backend.
struct UserProfile: Codable {
    var username: String  // The unique username chosen by the user
    var displayName: String  // The display name chosen by the user
    var picture: String  // The URL or identifier of the user's profile picture
    var bio: String  // The bio written by the user
}

//Decodes the response from backend when fetching user profile data
struct UserProfileResponse: Codable {
    let sub: String  // The unique identifier for the user. This should match the sub claim from Auth0.
    let username: String  // The username chosen by the user.
    let displayName: String  // The display name chosen by the user.
    let picture: String  // The URL or identifier of the user's profile picture.
    let bio: String  // The bio written by the user.

    enum CodingKeys: String, CodingKey {
        case sub, username, displayName = "displayname", picture = "profile_picture", bio
    }
}

extension UserProfile {
    // Initial/reset state for UserProfile
    static var empty: Self {
        return UserProfile(username: "", displayName: "", picture: "", bio: "")
    }
    
    // Transforms UserProfile FROM the UserProfileResponse from the backend
    static func from(_ response: UserProfileResponse) -> Self {
        return UserProfile(
          username: response.username,
          displayName: response.displayName,
          picture: response.picture,
          bio: response.bio
        )
    }
}
