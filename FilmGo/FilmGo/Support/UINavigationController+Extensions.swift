//
//  UINavigationController+Extensions.swift
//  FilmGo
//
//  Created by 곽다은 on 5/1/25.
//

import UIKit

extension UINavigationController {
    func applyFGNavigationBarStyle(_ style: FGNavigationBarStyle) {
        let appearance = UINavigationBarAppearance()

        let backImage: UIImage = .back.withRenderingMode(.alwaysOriginal)
        appearance.setBackIndicatorImage(backImage, transitionMaskImage: backImage)

        switch style {
        case .large(let title):
            applyLargeStyle(title, appearance)
        case .clear:
            applyClearStyle(appearance)
        case .dark(let title):
            applyDarkStyle(title, appearance)
        }

        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.compactAppearance = appearance
    }
}

private extension UINavigationController {
    func applyLargeStyle(_ title: String?, _ appearance: UINavigationBarAppearance) {
        navigationBar.prefersLargeTitles = true
        appearance.configureWithTransparentBackground()
        appearance.shadowColor = .clear
        appearance.titleTextAttributes = [.foregroundColor: UIColor.baseWhite]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.baseWhite]
        topViewController?.navigationItem.title = title
    }

    func applyClearStyle(_ appearance: UINavigationBarAppearance) {
        navigationBar.prefersLargeTitles = false
        appearance.configureWithTransparentBackground()
        appearance.shadowColor = .clear
        appearance.titleTextAttributes = [.foregroundColor: UIColor.clear]
    }

    func applyDarkStyle(_ title: String?, _ appearance: UINavigationBarAppearance) {
        navigationBar.prefersLargeTitles = false
        appearance.configureWithOpaqueBackground()
        appearance.shadowColor = .neutrals400
        appearance.backgroundColor = .neutrals800
        appearance.titleTextAttributes = [.foregroundColor: UIColor.baseWhite]
        topViewController?.navigationItem.title = title
    }
}

extension UINavigationController {
    enum FGNavigationBarStyle {
        case large(title: String?)
        case clear
        case dark(title: String?)
    }
}
