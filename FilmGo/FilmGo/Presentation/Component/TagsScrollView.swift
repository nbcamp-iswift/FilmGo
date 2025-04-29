//
//  TagsScrollView.swift
//  FilmGo
//
//  Created by youseokhwan on 4/29/25.
//

import UIKit
import SnapKit

final class TagsScrollView: UIScrollView {
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    func updateTags(_ texts: [String], _ isDeletable: Bool = false) {
        texts.forEach {
            let tagView = TagView(isDeletable: isDeletable)
            tagView.updateLabel($0)
            stackView.addArrangedSubview(tagView)
        }
    }
}

private extension TagsScrollView {
    func configure() {
        setAttributes()
        setHierarchy()
        setConstraints()
        setDelegate()
    }

    func setAttributes() {
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
    }

    func setHierarchy() {
        addSubview(stackView)
    }

    func setConstraints() {
        stackView.snp.makeConstraints { make in
            make.edges.height.equalToSuperview()
        }
    }

    func setDelegate() {
        delegate = self
    }
}

extension TagsScrollView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == self else { return }
        scrollView.contentOffset.y = 0
    }
}
