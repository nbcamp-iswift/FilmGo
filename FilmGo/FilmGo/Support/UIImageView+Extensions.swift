//
//  UIImageView+Extensions.swift
//  FilmGo
//
//  Created by youseokhwan on 5/1/25.
//

import UIKit

extension UIImageView {
    func setProgressiveImage(by path: String) {
        Task {
            if let lowImageData = await DefaultNetworkService().downloadImage(
                path: path,
                size: .w154
            ) {
                self.image = UIImage(data: lowImageData)

                if let highImageData = await DefaultNetworkService().downloadImage(
                    path: path,
                    size: .w500
                ) {
                    self.image = UIImage(data: highImageData)
                }
            }
        }
    }
}
