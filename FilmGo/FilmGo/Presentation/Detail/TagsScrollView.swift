//
//  TagsScrollView.swift
//  FilmGo
//
//  Created by youseokhwan on 4/29/25.
//

import UIKit
import SnapKit

// MARK: - TagsScrollView

final class TagsScrollView: UIScrollView {
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = .init(top: 0, leading: 16, bottom: 0, trailing: 16)
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
            let tagView = TagView()
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
}

// MARK: - TagView

private final class TagView: UIView {
    private let label: UILabel = {
        let label = UILabel()
        label.text = "label"
        label.textColor = .neutrals100
        label.font = .systemFont(ofSize: 11.9)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    func updateLabel(_ text: String) {
        label.text = text
    }
}

private extension TagView {
    func configure() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }

    func setAttributes() {
        backgroundColor = .neutrals600
        layer.cornerRadius = 18
        clipsToBounds = true
    }

    func setHierarchy() {
        addSubview(label)
    }

    func setConstraints() {
        label.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(4)
            make.directionalHorizontalEdges.equalToSuperview().inset(12)
            make.height.equalTo(28)
        }
    }
}
