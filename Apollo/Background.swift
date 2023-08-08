//
//  Background.swift
//  Apollo_Alpha
//
//  Created by Jacob Franco on 3/3/23.
//

import SwiftUI

struct Background: View {
    var primary = Color("Primary")
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        Group {
            if colorScheme == .dark {
                // Dark scheme 
                ZStack {
                            // Background Gradient
                    Color.black.ignoresSafeArea(.all)
                            
                            
                    VisualEffectView(effect: UIBlurEffect(style: .systemThickMaterial))
                        .opacity(0.1)
                        .ignoresSafeArea(.all)
                        }
                
                            
            } else {
                // Your original background for light mode
                let colors = [
                    Color.black.opacity(0.0),
                    Color.black.opacity(0.0),
                    primary.opacity(1.0),
                    Color.black.opacity(0.0)
                ]

                let startPoint = UnitPoint(x: -0.5, y: -0.5)
                let endPoint = UnitPoint(x: 2, y: 2)

                LinearGradient(gradient: Gradient(colors: colors), startPoint: startPoint, endPoint: endPoint)
                    .edgesIgnoringSafeArea(.all)
                    .background(BlurView(style: .systemUltraThinMaterial).ignoresSafeArea())
            }
        }
    }
}

struct Background_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Background()
                .previewDisplayName("Light mode")
                .environment(\.colorScheme, .light)
            
            Background()
                .previewDisplayName("Dark mode")
                .environment(\.colorScheme, .dark)
        }
    }
}

