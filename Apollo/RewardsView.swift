//
//  RewardsView.swift
//  Apollo_Development
//
//  Created by Jacob Franco on 6/21/23.
//

import SwiftUI

struct RewardsView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        
        VStack {
            Text("Rewards")
        }
        .modifier(Title(title: "Rewards"))
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "chevron.left")
                .foregroundColor(Color("Scheme-Inverse"))
        })
    }
}

struct RewardsView_Previews: PreviewProvider {
    static var previews: some View {
        RewardsView()
    }
}
