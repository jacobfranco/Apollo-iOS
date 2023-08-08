//
//  SettingsView.swift
//  Apollo_Development
//
//  Created by Jacob Franco on 6/21/23.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var userViewModel: UserViewModel
    
    var body: some View {
        
        VStack {
            Text("Email: \(userViewModel.loggedInAuthProfile.email)")
            Button("Log out") {
                userViewModel.logout()
            }
        }
        .modifier(Title(title: "Settings"))
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "chevron.left")
                .foregroundColor(Color("Scheme-Inverse"))
        })
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(UserViewModel())
    }
}
