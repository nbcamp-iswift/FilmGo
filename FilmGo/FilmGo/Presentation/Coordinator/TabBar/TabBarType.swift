//
//  TabBarType.swift
//  FilmGo
//
//  Created by 유현진 on 5/1/25.
//

import UIKit

enum TabBarType: CaseIterable {
    case home
    case search
    case myPage

    init?(index: Int) {
        switch index {
        case 0:
            self = .home
        case 1:
            self = .search
        case 2:
            self = .myPage
        default:
            return nil
        }
    }

    var title: String {
        switch self {
        case .home:
            return "홈"
        case .search:
            return "검색"
        case .myPage:
            return "마이페이지"
        }
    }

    var image: UIImage {
        switch self {
        case .home:
            return .homeTab
        case .search:
            return .seachTab
        case .myPage:
            return .myPageTab
        }
    }

    var index: Int {
        switch self {
        case .home:
            return 0
        case .search:
            return 1
        case .myPage:
            return 2
        }
    }
}
