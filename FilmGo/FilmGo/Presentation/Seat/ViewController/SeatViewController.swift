//
//  SeatViewController.swift
//  FilmGo
//
//  Created by youseokhwan on 4/29/25.
//

import UIKit

final class SeatViewController: UIViewController {
    private let seatView = SeatView()

    override func loadView() {
        view = seatView
    }
}
