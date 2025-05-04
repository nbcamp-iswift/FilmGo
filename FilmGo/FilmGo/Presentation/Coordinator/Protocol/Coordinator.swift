//
//  Coordinator.swift
//  FilmGo
//
//  Created by 유현진 on 5/4/25.
//

import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get }
    func start()
}
