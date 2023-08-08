//
//  PostViewModel.swift
//  Apollo_Development
//
//  Created by Jacob Franco on 7/19/23.
//

import Foundation
import os.log
import Alamofire
import SimpleKeychain

class PostViewModel: ObservableObject {
    // Initialize logger and keychain
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "PostViewModel")
    private let keychain = SimpleKeychain(service: "com.jacobfranco.Apollo-Development")
    
    // Authenticates client to server
    @Published var accessToken: String?
    
    // Store the fetched post
    @Published var post: Post?
    
    init() {
        if let token = try? keychain.string(forKey: "idToken") {
            self.accessToken = token
        }
    }

    func createPost(content: String, userSub: String) {
        let url = Constants.Services.Post.baseURL + Constants.Services.Post.create
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(self.accessToken ?? "")"
        ]
        let parameters = [
            "content": content,
            "user_sub": userSub
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success:
                    self.logger.debug("Post created successfully")
                case .failure(let error):
                    self.logger.error("Failed to create post: \(error.localizedDescription)")
                }
            }
    }

    func fetchPost(byId id: String) {
        let url = Constants.Services.Post.baseURL + Constants.Services.Post.get + id
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(self.accessToken ?? "")"
        ]

        AF.request(url, method: .get, headers: headers)
            .validate()
            .responseDecodable(of: Post.self) { response in
                switch response.result {
                case .success(let fetchedPost):
                    self.post = fetchedPost
                case .failure(let error):
                    self.logger.error("Failed to fetch post: \(error.localizedDescription)")
                }
            }
    }

    func deletePost(byId id: String) {
        let url = Constants.Services.Post.baseURL + Constants.Services.Post.delete + id
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(self.accessToken ?? "")"
        ]

        AF.request(url, method: .delete, headers: headers)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success:
                    self.logger.debug("Post deleted successfully")
                case .failure(let error):
                    self.logger.error("Failed to delete post: \(error.localizedDescription)")
                }
            }
    }
}
