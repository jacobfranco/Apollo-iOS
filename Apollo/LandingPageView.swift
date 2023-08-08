//
//  LandingPageView.swift
//  Apollo_Development
//
//  Created by Jacob Franco on 7/12/23.
//

import SwiftUI

struct LandingPageView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    var body: some View {
        ZStack {
            Background()
                .ignoresSafeArea(.all)
            VStack {
                Spacer()
                Text("Welcome to Apollo")
                    .modifier(h1())
                    .padding()
                    .foregroundColor(Color("Primary"))
                Text("Continue to log in or create your account")
                    .modifier(h3())
                    .foregroundColor(Color("Primary"))
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                Button("Continue") {
                    userViewModel.login()
                }
                .buttonStyle(SingleButton())
                .foregroundColor(Color("Scheme"))
                Spacer()
            } // END VStack
        } // END ZStack
    }
}

struct LandingPageView_Previews: PreviewProvider {
    static var previews: some View {
        LandingPageView()
    }
}
