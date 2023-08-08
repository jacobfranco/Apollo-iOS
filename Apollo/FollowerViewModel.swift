//
//  FollowerViewModel.swift
//  Apollo_Development
//
//  Created by Jacob Franco on 7/27/23.
//

import Foundation
import os.log
import Alamofire
import SimpleKeychain

class FollowerViewModel: ObservableObject {
    // Initialize logger and keychain
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "FollowerViewModel")
    private let keychain = SimpleKeychain(service: "com.jacobfranco.Apollo-Development")
    
    @Published var accessToken: String?
    @Published var followingUsers:  [UserProfile] = []
    @Published var followers:  [UserProfile] = []
    @Published var isFollowingProfileUser: Bool = false
    
    var currentPage: Int = 1
    var isFetching = false
    
    init() {
        // Assuming the `accessToken` is fetched and saved the same way as in UserViewModel
        // If there's a different way for this ViewModel, it should be updated accordingly.
        if let token = try? keychain.string(forKey: "idToken") {
            self.accessToken = token
        }
    }

    func followUser(username: String) {
        sendFollowAction(username: username, endpoint: Constants.Services.Follower.follow, successMessage: "Successfully followed user", failureMessage: "Failed to follow user")
    }

    func unfollowUser(username: String) {
        sendFollowAction(username: username, endpoint: Constants.Services.Follower.unfollow, successMessage: "Successfully unfollowed user", failureMessage: "Failed to unfollow user")
    }

    private func sendFollowAction(username: String, endpoint: String, successMessage: String, failureMessage: String) {
        let url = Constants.Services.User.baseURL + endpoint
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(self.accessToken ?? "")"
        ]
        let parameters = ["username": username]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success:
                    self.logger.debug("\(endpoint) action success")
                case .failure(let error):
                    self.logger.error("\(failureMessage): \(error.localizedDescription)")
                }
            }
    }
    
    func fetchFollowingUsers(forUsername username: String, page: Int = 1) {
        fetchFollowAction(username: username, endpoint: Constants.Services.Follower.following, page: page, limit: 50) { users in
            self.followingUsers = users
        }
    }

    func fetchFollowers(forUsername username: String, page: Int = 1) {
        fetchFollowAction(username: username, endpoint: Constants.Services.Follower.followers, page: page, limit: 50) { users in
            self.followers = users
        }
    }

    private func fetchFollowAction(username: String, endpoint: String, page: Int, limit: Int, completion: @escaping ([UserProfile]) -> ()) {
        guard !isFetching else { return }

        isFetching = true
        let url = Constants.Services.User.baseURL + endpoint + username
        let parameters: [String: Any] = ["page": page, "limit": limit]
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(self.accessToken ?? "")"
        ]

        AF.request(url, method: .get, parameters: parameters, headers: headers)
            .validate()
            .responseDecodable(of: [UserProfile].self) { response in
                self.isFetching = false
                switch response.result {
                case .success(let userProfiles):
                    completion(userProfiles)
                    self.currentPage += 1
                case .failure(let error):
                    self.logger.error("Failed to fetch data from \(endpoint): \(error.localizedDescription)")
                }
            }
    }

    
    func checkIfFollowing(loggedInUsername: String, displayedUsername: String, completion: @escaping (Result<Bool, Error>) -> Void) {
            
        guard !loggedInUsername.isEmpty, !displayedUsername.isEmpty else {
                completion(.failure(NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "Usernames should not be empty"])))
                return
            }

            let url = "http://yourFollowerServiceURL:8083/relationshipstatus/\(loggedInUsername)/\(displayedUsername)"

            AF.request(url).validate().responseJSON { response in
                switch response.result {
                case .success(let value):
                    if let json = value as? [String: String], let status = json["status"] {
                        completion(.success(status == "Following"))
                    } else {
                        completion(.failure(NSError(domain: "", code: 500, userInfo: [NSLocalizedDescriptionKey: "Unexpected response format"])))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    
    func toggleFollowStatus(loggedInUsername: String, displayedUsername: String) {
        checkIfFollowing(loggedInUsername: loggedInUsername, displayedUsername: displayedUsername) { result in
            switch result {
            case .success(let isFollowing):
                if isFollowing {
                    self.unfollowUser(username: displayedUsername)
                } else {
                    self.followUser(username: displayedUsername)
                }
            case .failure(let error):
                // Handle or propagate the error if you need to
                print(error.localizedDescription)
            }
        }
    }


}



