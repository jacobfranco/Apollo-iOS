//
//  Modifiers.swift
//  Apollo_Development
//
//  Created by Jacob Franco on 6/10/23.
//

import Foundation
import SwiftUI
import TabBar

// - READ ME - //
// - Table of Contents
// - - - Text Modifiers
// - - - Button Modifiers
// - - - Navigation Modifiers
// - - - Tab Modifiers
// - - - Backgrund Modifiers

// MARK: Text Modifiers

struct Title: ViewModifier {
    var title: String

    func body(content: Content) -> some View {
        content
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text(title)
                        .modifier(h2())
                }
            }
    }
}

struct h1Light: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(Font.custom("URWDIN-Light", size: 32))
    }
}

struct h2Light: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(Font.custom("URWDIN-Light", size: 24))
    }
}

struct h3Light: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(Font.custom("URWDIN-Light", size: 16))
    }
}

struct h1: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(Font.custom("URWDIN-Regular", size: 32))
    }
}

struct h2: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(Font.custom("URWDIN-Regular", size: 24))
    }
}

struct h3: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(Font.custom("URWDIN-Regular", size: 16))
    }
}

struct h4: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(Font.custom("URWDIN-Regular", size: 14))
    }
}

struct h5: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(Font.custom("URWDIN-Regular", size: 12))
    }
}

struct DisplayName: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(Font.custom("URWDIN-Regular", size: 12))
    }
}

struct Username: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(Font.custom("URWDIN-Light", size: 12))
    }
}

struct Pipe: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(Font.custom("URWDIN-Light", size: 14))
            .foregroundColor(.gray)
    }
}

struct Detail: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(Font.custom("URWDIN-Light", size: 12))
            .foregroundColor(.gray)
    }
}

// MARK: Button Modifiers
struct SingleButton: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(width: 275, height: 45)
            .font(.custom("URWDIN-Regular", size: 16))
            .foregroundColor(Color("Scheme"))
            .background(Color("Primary"))
            .cornerRadius(5.0)
            .shadow(color: Color("Scheme-Inverse").opacity(0.7), radius: 1)
    }
}

struct MetricStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(Font.custom("URWDIN-Regular", size: 12))
            .foregroundColor(Color.primary)
    }
}

struct IconStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(Color.gray)
    }
}

// MARK: Object Modifiers

struct InformationField: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(Font.custom("URWDIN-Regular", size: 14))
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .strokeBorder(Color("Scheme-Inverse"), lineWidth: 1)
            )
            .foregroundColor(Color("Scheme-Inverse"))
    }
}
// MARK: Navigation Modifiers

extension View {
    func navigationBarTransparentBackground() -> some View {
        self
            .background(NavigationConfigurator { nc in
                nc.navigationBar.setBackgroundImage(UIImage(), for: .default)
                nc.navigationBar.shadowImage = UIImage()
            })
    }
}

struct NavigationConfigurator: UIViewControllerRepresentable {
    var configure: (UINavigationController) -> Void = { _ in }

    func makeUIViewController(context: UIViewControllerRepresentableContext<NavigationConfigurator>) -> UIViewController {
        UIViewController()
    }
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<NavigationConfigurator>) {
        if let nc = uiViewController.navigationController {
            self.configure(nc)
        }
    }
}

func setNavBarAppearance(for colorScheme: ColorScheme) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.shadowColor = .clear
        
        switch colorScheme {
        case .dark:
            appearance.backgroundColor = .black
        default:
            appearance.backgroundColor = .white
        }

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }

// MARK: Tab Modifiers

enum TabItem: Int, Tabbable {
    case first = 0
    case second
    case third
    case fourth
    
    var icon: String {
        switch self {
            case .first:  return "house"
            case .second: return "magnifyingglass"
            case .third:  return "gamecontroller"
            case .fourth: return "person"
        }
    }
    
    var title: String {
        switch self {
            case .first:  return "Home"
            case .second: return "Search"
            case .third:  return "Fantasy"
            case .fourth: return "Profile"
        }
    }
}

struct CustomTabBarStyle: TabBarStyle {
    
    public func tabBar(with geometry: GeometryProxy, itemsContainer: @escaping () -> AnyView) -> some View {
        ZStack(alignment: .bottom) {
            VStack {
                Spacer()
                BlurColorView(style: .systemUltraThinMaterial, color: UIColor(named: "Scheme")!).opacity(0.95)
                    .frame(height: 50.0 + geometry.safeAreaInsets.bottom)
                    .cornerRadius(5.0)
            }.edgesIgnoringSafeArea(.bottom)

            itemsContainer()
                .frame(height: 50.0)
                .padding(.bottom, geometry.safeAreaInsets.bottom)
        }
    }
}

struct CustomTabItemStyle: TabItemStyle {
    
    public func tabItem(icon: String, title: String, isSelected: Bool) -> some View {
        Image(systemName: icon)
            .foregroundColor(isSelected ? Color("Primary") : .gray)
            .frame(width: 32.0, height: 32.0)
            .padding(.vertical, 8.0)
    }
}

// MARK: Background Modifiers

struct BlurView: UIViewRepresentable {
    let style: UIBlurEffect.Style

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        let blurEffect = UIBlurEffect(style: style)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(blurView)
        NSLayoutConstraint.activate([
            blurView.heightAnchor.constraint(equalTo: view.heightAnchor),
            blurView.widthAnchor.constraint(equalTo: view.widthAnchor),
        ])
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        // No need to update the view, as the blur effect style is set in makeUIView.
    }
}

struct BlurColorView: UIViewRepresentable {
    let style: UIBlurEffect.Style
    let color: UIColor

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        let blurEffect = UIBlurEffect(style: style)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.backgroundColor = color.withAlphaComponent(0.7)
        view.addSubview(blurView)
        NSLayoutConstraint.activate([
            blurView.heightAnchor.constraint(equalTo: view.heightAnchor),
            blurView.widthAnchor.constraint(equalTo: view.widthAnchor),
        ])
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        // No need to update the view, as the blur effect style is set in makeUIView.
    }
}

struct VisualEffectView: UIViewRepresentable {
    var effect: UIVisualEffect?
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView {
        return UIVisualEffectView(effect: effect)
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) {
        uiView.effect = effect
    }
}

// MARK: Date Modifier

func formattedTimeElapsed(since dateStr: String, with format: String = "yyyy-MM-dd'T'HH:mm:ssZ") -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)  // We set this to UTC because our date string is in UTC

    guard let date = dateFormatter.date(from: dateStr) else {
        return "Invalid Date"
    }

    // Convert the date from UTC to the user's local time zone
    dateFormatter.timeZone = TimeZone.current
    let localDateStr = dateFormatter.string(from: date)
    let localDate = dateFormatter.date(from: localDateStr)!

    let now = Date()
    let interval = now.timeIntervalSince(localDate)

    if interval < 60 {
        return "\(Int(interval))s"
    } else if interval < 3600 {
        return "\(Int(interval / 60))m"
    } else if interval < 86400 {
        return "\(Int(interval / 3600))h"
    } else if interval < 604800 {
        return "\(Int(interval / 86400))d"
    } else if interval < 2419200 { // 4 weeks = 1 month approximation
        return "\(Int(interval / 604800))w"
    } else if interval < 29030400 { // 12 months = 1 year approximation
        return "\(Int(interval / 2419200))mo"
    } else {
        return "\(Int(interval / 29030400))y"
    }
}
