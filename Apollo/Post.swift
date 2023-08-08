//
//  Post.swift
//  Apollo_Development
//
//  Created by Jacob Franco on 7/10/23.
//

import Foundation

struct Post: Codable {
    let id: String
    let author: UserProfile
    let body: String
    let created_at: String
}

