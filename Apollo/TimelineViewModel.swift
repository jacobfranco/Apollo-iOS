//
//  TimelineViewModel.swift
//  Apollo_Development
//
//  Created by Jacob Franco on 7/19/23.
//

import Foundation
import Alamofire

class TimelineViewModel: ObservableObject {
    
    @Published var userTimelinePosts: [Post] = []
    @Published var followingTimelinePosts: [Post] = []
    
    func fetchUserTimeline(username: String, page: Int) {
        let url = "\(Constants.Services.Timeline.baseURL)/timeline/me"
        let parameters: [String: Any] = ["username": username, "page": page]

        AF.request(url, parameters: parameters).validate().responseDecodable(of: [Post].self) { response in
            switch response.result {
            case .success(let posts):
                DispatchQueue.main.async {
                    self.userTimelinePosts = posts
                }
            case .failure(let error):
                print("Failed to decode JSON: \(error)")
            }
        }
    }
    
    func fetchFollowingTimeline(username: String, page: Int) {
        let url = "\(Constants.Services.Timeline.baseURL)/timeline/following"
        let parameters: [String: Any] = ["username": username, "page": page]

        AF.request(url, parameters: parameters).validate().responseDecodable(of: [Post].self) { response in
            switch response.result {
            case .success(let posts):
                DispatchQueue.main.async {
                    self.followingTimelinePosts = posts
                }
            case .failure(let error):
                print("Failed to decode JSON: \(error)")
            }
        }
    }
}

