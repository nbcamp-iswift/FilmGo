//
//  DetailViewController.swift
//  FilmGo
//
//  Created by youseokhwan on 4/28/25.
//

import UIKit

final class DetailViewController: UIViewController {
    private let detailView = DetailView()

    override func loadView() {
        view = detailView
    }
}
