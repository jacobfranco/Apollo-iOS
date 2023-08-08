//
//  UpdateProfileView.swift
//  Apollo_Development
//
//  Created by Jacob Franco on 6/16/23.
//

import SwiftUI

struct UpdateProfileView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @State var username: String = ""
    @State var displayName: String = ""
    @State var bio: String = ""
    @State var picture: UIImage? = nil
    @State private var showingImagePicker = false

    private let bioLimit = 80

    var body: some View {
        NavigationView {
            
            ZStack {
                Background()
                    .ignoresSafeArea(.all)
                VStack {
                    Spacer()
                    
                    TextField("Username", text: $username)
                        .modifier(InformationField())
                        .padding([.leading, .trailing], 20)
                    
                    TextField("Display Name", text: $displayName)
                        .modifier(InformationField())
                        .padding([.leading, .trailing], 20)

                    TextField("Bio", text: $bio)
                        .modifier(InformationField())
                        .padding([.leading, .trailing], 20)
                        .onReceive(bio.publisher.collect()) {
                            let newBio = String($0.prefix(self.bioLimit))
                            if self.bio != newBio {
                                self.bio = newBio
                            }
                        }

                    Text("Bio limit: \(bio.count)/\(bioLimit)")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding([.leading, .trailing], 20)


                    Button("Select Image") {
                        self.showingImagePicker = true
                    }
                    .buttonStyle(SingleButton())
                    .sheet(isPresented: $showingImagePicker) {
                        ImagePicker(image: self.$picture)
                    }
                    
                    if let picture = picture {
                        Image(uiImage: picture)
                            .resizable()
                            .frame(width: 100, height: 100)
                    }

                    Spacer()

                    Button("Continue") {
                        // Call your backend to update the profile
                        // After the profile update succeeds, set `userViewModel.profileComplete` to `true`
                        userViewModel.registerProfile(username: username, displayName: displayName, bio: bio, picture: picture)
                    }
                    .buttonStyle(SingleButton())
                    Button("Mock Login") {
                        userViewModel.mockLogin()
                    }
                    
                }
                .modifier(Title(title: "Profile Details"))
            }
            
        }
    }
}

struct UpdateProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateProfileView()
    }
}
