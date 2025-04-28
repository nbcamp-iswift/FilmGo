//
//  TagView.swift
//  FilmGo
//
//  Created by youseokhwan on 4/28/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class TagView: UIView {
    private var isDeletable: Bool
    private let disposeBag = DisposeBag()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        return stackView
    }()

    private let textButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = .neutrals100
        config.contentInsets = .zero
        config.attributedTitle = .init(
            "label",
            attributes: .init([.font: UIFont.systemFont(ofSize: 11.9)]),
        )
        let button = UIButton(configuration: config)
        return button
    }()

    private let deleteButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "xmark")
        config.baseForegroundColor = .neutrals200
        config.contentInsets = .zero
        let button = UIButton(configuration: config)
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 10, weight: .heavy)
        button.configuration?.preferredSymbolConfigurationForImage = symbolConfig
        return button
    }()

    init(isDeletable: Bool = false) {
        self.isDeletable = isDeletable
        super.init(frame: .zero)
        configure()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    func updateLabel(_ text: String) {
        guard var config = textButton.configuration else { return }
        config.title = text
        textButton.configuration = config
    }
}

private extension TagView {
    func configure() {
        setAttributes()
        setHierarchy()
        setConstraints()
        setBindings()
    }

    func setAttributes() {
        backgroundColor = .neutrals600
        layer.cornerRadius = 18
        clipsToBounds = true
    }

    func setHierarchy() {
        stackView.addArrangedSubview(textButton)
        if isDeletable {
            stackView.addArrangedSubview(deleteButton)
        }
        addSubview(stackView)
    }

    func setConstraints() {
        stackView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(4)
            make.directionalHorizontalEdges.equalToSuperview().inset(12)
            make.height.equalTo(28)
        }
    }

    func setBindings() {
        deleteButton.rx.tap
            .bind { [weak self] _ in
                self?.removeFromSuperview()
            }
            .disposed(by: disposeBag)
    }
}
