//
//  MessagesView.swift
//  Apollo_Development
//
//  Created by Jacob Franco on 6/11/23.
//

import SwiftUI

struct MessagesView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        
        VStack {
            Text("Messages")
        }
        .modifier(Title(title: "Messages"))
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "chevron.left")
                .foregroundColor(Color("Scheme-Inverse"))
        })
    }
}

struct MessagesView_Previews: PreviewProvider {
    static var previews: some View {
        MessagesView()
    }
}
