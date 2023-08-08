//
//  UserListView.swift
//  Apollo_Development
//
//  Created by Jacob Franco on 8/7/23.
//

import SwiftUI

struct UserListView: View {
    
    var users: [UserProfile]
    
    var body: some View {
            ZStack {
                Background()
                    .ignoresSafeArea(.all)
                ScrollView {
                            VStack {
                                ForEach(users, id: \.username) { user in
                                                    UserListItemView(userProfile: user)
                                                }
                            }
                        }
        }
        
    }
}

