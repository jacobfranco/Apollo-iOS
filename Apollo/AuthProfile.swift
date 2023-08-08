//
//  AuthProfile.swift
//  Apollo_Development
//
//  Created by Jacob Franco on 7/10/23.
//

import Foundation
import JWTDecode

// AuthProfile is a structure that is used to store the profile data that is received from Auth0 during user authentication.
struct AuthProfile: Decodable {
    let sub: String  // The unique identifier for the user. This is given by Auth0.
    let email: String  // The email address of the user.
    let emailVerified: Bool  // Indicates whether the user has verified their email address.
    let updatedAt: String  // The timestamp of when the user's profile was last updated.
}

extension AuthProfile {
    // Initial/reset empty state for an AuthProfile
    static var empty: Self {
        return AuthProfile(sub: "", email: "", emailVerified: false, updatedAt: "")
    }
    
    // Forms an Auth0 profile FROM decoding an ID Token
    static func from(_ idToken: String) -> Self {
        // Attempt to decode the JWT from the idToken string
        guard
          let jwt = try? decode(jwt: idToken),
          let sub = jwt.subject,
          let email = jwt.claim(name: "email").string,
          let emailVerified = jwt.claim(name: "email_verified").boolean,
          let updatedAt = jwt.claim(name: "updated_at").string
        else {
          return .empty  // If any extraction fails, return an empty AuthProfile
        }

        // If all extractions are successful, return a new AuthProfile with the extracted claims
        return AuthProfile(
          sub: sub,
          email: email,
          emailVerified: emailVerified,
          updatedAt: updatedAt
        )
    }
}
