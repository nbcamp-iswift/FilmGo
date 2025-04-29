//
//  UICollectionViewCell+Extensions.swift
//  FilmGo
//
//  Created by 곽다은 on 4/29/25.
//

import UIKit

extension UICollectionViewCell {
    static var reuseIdentifier: String {
        String(describing: self)
    }
}
