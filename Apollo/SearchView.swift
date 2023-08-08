//
//  SearchView.swift
//  apollo
//
//  Created by Jacob Franco on 6/9/23.
//

import SwiftUI

struct SearchView: View {
    
    @EnvironmentObject var userViewModel: UserViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                Background()
                    .ignoresSafeArea(.all)

                
                VStack {
                    ScrollView {
                        Text("Search View")
                    }
                }
                .modifier(Title(title: "Search"))
                .navigationBarItems(trailing: NavigationLink(destination: FavoritesView()) {
                    Image(systemName: "heart")
                        .foregroundColor(Color("Scheme-Inverse"))
                })
                .navigationBarTransparentBackground()
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
