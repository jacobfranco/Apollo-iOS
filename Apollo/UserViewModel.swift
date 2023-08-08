//
//  UserViewModel.swift
//  apollo
//
//  Created by Jacob Franco on 6/9/23.
//

// UserViewModel.swift
import Foundation
import Auth0
import UIKit
import os.log
import JWTDecode
import SimpleKeychain
import Alamofire

class UserViewModel: ObservableObject {
    //Initialize logger and keychain
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "UserViewModel")
    private let keychain = SimpleKeychain(service: "com.jacobfranco.Apollo-Development")
    
    // Published wrappers notifies the View about changes to the value
    // They are stored in UserDefaults for persistence across app launches
    
    //Denotes that user is authenticated via Auth0
    @Published var authenticated: Bool {
        didSet {
            UserDefaults.standard.set(authenticated, forKey: "authenticated")
        }
    }
    
    //Denotes that user is authenticated via Auth0
    @Published var profileComplete: Bool {
        didSet {
            UserDefaults.standard.set(profileComplete, forKey: "profilecComplete")
        }
    }
    
    //Current logged in user's Auth0 profile - default value is empty
    @Published var loggedInAuthProfile = AuthProfile.empty
    
    //Current logged in user's Apollo profile - default value is empty
    @Published var loggedInUserProfile = UserProfile.empty
    
    // Currently displayed user's Auth0 profile - default value is empty
    @Published var displayedAuthProfile = AuthProfile.empty
    
    // Currently displayed user's Apollo profile - default value is empty
    @Published var displayedUserProfile = UserProfile.empty
    
    //Authenticates client to server
    @Published var accessToken: String?
    
    //For user profile caching
    private let userProfileKey = "loggedInUserProfile"
    
    init() {
        //Fetches values from UserDefaults and assigns to variables
        authenticated = UserDefaults.standard.bool(forKey: "authenticated")
        profileComplete = UserDefaults.standard.bool(forKey: "profileComplete")
        
        // Check if there is a saved idToken in keychain. If it exists, decode the token and save the user and auth profiles.
        if let token = try? keychain.string(forKey: "idToken") {
            self.loggedInAuthProfile = AuthProfile.from(token)
            fetchProfile(bySub: self.loggedInAuthProfile.sub) { profileExists in
                DispatchQueue.main.async {
                    if profileExists {
                        print("Profile exists in database")
                        self.profileComplete = true
                    } else {
                        print("Profile does not exist in database, prompting registration")
                        self.profileComplete = false
                    }
                }
            }
        } else {
            self.loggedInAuthProfile = AuthProfile.empty
            self.loggedInUserProfile = UserProfile.empty
        }
        
        // Load the user profile from UserDefaults
        loadUserProfile()
    }
    
    // The `login` function is used to authenticate the user and get access and ID tokens
    func login() {
        // Start the Auth0 Web Authentication Flow
        Auth0.webAuth()
            .scope("openid profile email offline_access")
        //.audience("API GATEWAY")  //ADD THIS IN WHEN INTEGRATING KUBERNETES + API GATEWAY
        // Begin the authentication process
            .start { result in
                switch result {
                    // If the process failed, log the error
                case .failure(let error):
                    self.logger.error("Login failed with error: \(error.localizedDescription)")
                    // If the process succeeded, update the application state
                case .success(let credentials):
                    // Set the user as authenticated
                    self.authenticated = true
                    // Save the access token
                    self.accessToken = credentials.accessToken
                    // Save the id token
                    let idToken = credentials.idToken
                    // Attempt to save the id token in the keychain
                    _ = try? self.keychain.set(idToken, forKey: "idToken")
                    // Attempt to decode the id token to get user profile information
                    if let jwt = try? decode(jwt: idToken),
                       //Extract profile information
                       let sub = jwt.claim(name: "sub").string,
                       let email = jwt.claim(name: "email").string,
                       let emailVerified = jwt.claim(name: "email_verified").boolean,
                       let updatedAt = jwt.claim(name: "updated_at").string
                    {
                        // Set the Auth profile with the extracted claims
                        self.loggedInAuthProfile = AuthProfile(sub: sub, email: email, emailVerified: emailVerified, updatedAt: updatedAt)
                        
                        // Check if user profile exists in the database - if true, set userProfile, if false, profileComplete=false
                        self.fetchProfile(bySub: self.loggedInAuthProfile.sub) { profileExists in
                            DispatchQueue.main.async {
                                if profileExists {
                                    print("Profile exists in database")
                                    self.profileComplete = true
                                } else {
                                    print("Profile does not exist in database, prompting registration")
                                    self.profileComplete = false
                                }
                            }
                        }
                    }
                    self.logger.debug("Login successful with accessToken: \(credentials.accessToken)")
                    self.logger.debug("Login successful with idToken: \(credentials.idToken)")
                    
                }
            }
        // After user has logged in, update the user profile data
        updateProfileData()
    }
    
    
    
    func logout() {
        Auth0.webAuth().clearSession() { result in
            switch result {
            case .failure(let error):
                self.logger.error("Logout failed with error: \(error.localizedDescription)")
            case .success:
                self.authenticated = false
                self.profileComplete = false
                self.loggedInAuthProfile = AuthProfile.empty
                self.loggedInAuthProfile = AuthProfile.empty
                _ = try? self.keychain.deleteItem(forKey: "idToken")
                UserDefaults.standard.removeObject(forKey: self.userProfileKey)
                self.logger.debug("Logout successful")
            }
        }
    }
    
    func registerProfile(username: String, displayName: String, bio: String, picture: UIImage?) {
        let endpoint = Constants.Services.User.baseURL + Constants.Services.User.register
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(self.accessToken ?? "")"
        ]
        let pictureUrl = "" // Placeholder
        let parameters: [String: Any] = [
            "sub": self.loggedInAuthProfile.sub,
            "username": username,
            "displayname": displayName,
            "bio": bio,
            "profile_picture": pictureUrl
        ]
        self.logger.debug("Register profile with body: \(parameters)")

        AF.request(endpoint, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success:
                    self.logger.debug("Profile registration successful")
                    DispatchQueue.main.async {
                        self.profileComplete = true
                        self.fetchProfile(bySub: self.loggedInAuthProfile.sub) { _ in }
                    }
                case .failure(let error):
                    self.logger.error("Failed to register profile: \(error.localizedDescription)")
                }
            }
    }

    
    func fetchProfile(byUsername username: String, completion: @escaping (Bool) -> ()) {
        let endpoint = Constants.Services.User.baseURL + Constants.Services.User.user + username
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(self.accessToken ?? "")"
        ]

        AF.request(endpoint, method: .get, headers: headers)
            .validate()
            .responseDecodable(of: UserProfileResponse.self) { response in
                switch response.result {
                case .success(let profileResponse):
                    DispatchQueue.main.async {
                        if self.loggedInAuthProfile.sub == profileResponse.sub {
                            self.loggedInUserProfile = UserProfile.from(profileResponse)
                        }
                        self.displayedUserProfile = UserProfile.from(profileResponse)
                        completion(true)
                    }
                case .failure:
                    DispatchQueue.main.async {
                        completion(false)
                    }
                }
            }
    }
    
    func fetchProfile(bySub sub: String, completion: @escaping (Bool) -> ()) {
        // Encode the sub string properly
        guard let encodedSub = sub.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            print("Failed to encode sub.")
            completion(false)
            return
        }
        
        let endpoint = Constants.Services.User.baseURL + Constants.Services.User.profile + encodedSub
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(self.accessToken ?? "")"
        ]

        let startTime = Date()
        AF.request(endpoint, method: .get, headers: headers)
            .validate()
            .responseDecodable(of: UserProfileResponse.self) { response in
                switch response.result {
                case .success(let profileResponse):
                    DispatchQueue.main.async {
                        if self.loggedInAuthProfile.sub == profileResponse.sub {
                            self.loggedInUserProfile = UserProfile.from(profileResponse)
                        }
                        self.displayedUserProfile = UserProfile.from(profileResponse)
                        completion(true)
                    }
                case .failure:
                    DispatchQueue.main.async {
                        completion(false)
                    }
                }
                let elapsedTime = Date().timeIntervalSince(startTime)
                print("Elapsed time: \(elapsedTime) seconds")
            }
    }

    private func handleResponse(data: Data?, response: URLResponse?, error: Error?, successMessage: String, failureMessage: String) {
        if let error = error {
            self.logger.error("\(failureMessage) with error: \(error.localizedDescription)")
        } else if let response = response as? HTTPURLResponse, response.statusCode == 200 {
            if !successMessage.isEmpty {
                self.logger.debug("\(successMessage)")
            }
            if let data = data {
                let dataString = String(data: data, encoding: .utf8)
                self.logger.debug("Data received: \(String(describing: dataString))")
            }
        } else {
            self.logger.error("\(failureMessage)")
            if let response = response as? HTTPURLResponse {
                self.logger.debug("Response status code: \(response.statusCode)")
            }
            if let data = data {
                let dataString = String(data: data, encoding: .utf8)
                self.logger.debug("Data received: \(String(describing: dataString))")
            }
        }
    }
    
    func isCurrentUser() -> Bool {
        return displayedUserProfile.username == loggedInUserProfile.username
    }
    
    // Save the user profile to UserDefaults
    func saveUserProfile() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(loggedInUserProfile) {
            UserDefaults.standard.set(encoded, forKey: userProfileKey)
        }
    }
    
    // Load the user profile from UserDefaults
    func loadUserProfile() {
        if let savedUserProfile = UserDefaults.standard.object(forKey: userProfileKey) as? Data {
            let decoder = JSONDecoder()
            if let loadedUserProfile = try? decoder.decode(UserProfile.self, from: savedUserProfile) {
                self.loggedInUserProfile = loadedUserProfile
            }
        }
    }
    
    // Update the user profile
    func updateProfileData() {
        fetchProfile(bySub: self.loggedInAuthProfile.sub) { profileExists in
            DispatchQueue.main.async {
                if profileExists {
                    print("Profile exists in database")
                    self.profileComplete = true
                } else {
                    print("Profile does not exist in database, prompting registration")
                    self.profileComplete = false
                }
                // Save the profile to UserDefaults after fetching it from the server
                self.saveUserProfile()
            }
        }
    }
    
    // Mock Login - Remove before launch
    func mockLogin() {
            // Mimic being authenticated
            self.authenticated = true

            // Mimic profile being complete
            self.profileComplete = true

            // Set a mock AuthProfile
            self.loggedInAuthProfile = AuthProfile(sub: "1234567890", email: "mock@email.com", emailVerified: true, updatedAt: "2023-06-09")

            // Set a mock UserProfile
            self.loggedInUserProfile = UserProfile(username: "ApolloUser22", displayName: "#1 Apollo Fan", picture: "avi", bio: "I love this app")

            // If needed, set any other values you wish to mock here.
            
            // Save the mock data to UserDefaults
            saveUserProfile()
        }
}

