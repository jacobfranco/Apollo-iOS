//
//  Constants.swift
//  Apollo_Development
//
//  Created by Jacob Franco on 6/19/23.
//

import Foundation

struct Constants {
    
    struct Services {
        struct User {
            static let baseURL = "http://192.168.1.83:8080"
            static let register = "/register"
            static let user = "/user/" //for username query
            static let profile = "/profile/" //for sub query
        }
        
        struct Post {
            static let baseURL = "http://192.168.1.83:8082"
            static let create = "/new"
            static let get = "/get"
            static let delete = "/delete"
        }
        
        struct Follower {
            static let baseURL = "http://192.168.1.83:8083"
            static let follow = "/follow"
            static let unfollow = "/unfollow"
            static let following = "/following"
            static let followers = "/followers"
        }
        
        struct Timeline {
            static let baseURL = "http://192.168.1.83:8084"
        }
        
    }
}
