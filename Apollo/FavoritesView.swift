//
//  FavoritesView.swift
//  Apollo_Development
//
//  Created by Jacob Franco on 6/21/23.
//

import SwiftUI

struct FavoritesView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        
        VStack {
            Text("Favorites View")
        }
        .modifier(Title(title: "Favorites"))
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "chevron.left")
                .foregroundColor(Color("Scheme-Inverse"))
        })
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
    }
}
