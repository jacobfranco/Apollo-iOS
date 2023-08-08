//
//  FantasyView.swift
//  apollo
//
//  Created by Jacob Franco on 6/9/23.
//

import SwiftUI

struct FantasyView: View {
    
    @EnvironmentObject var userViewModel: UserViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                Background()
                    .ignoresSafeArea(.all)

                VStack {
                    ScrollView {
                        Text("Fantasy View")
                    }
                }
                .modifier(Title(title: "Fantasy"))
                .navigationBarItems(trailing: NavigationLink(destination: RewardsView()) {
                    Image(systemName: "crown")
                        .foregroundColor(Color("Scheme-Inverse"))
                })
            }
        }
    }
}

struct FantasyView_Previews: PreviewProvider {
    static var previews: some View {
        FantasyView()
    }
}
