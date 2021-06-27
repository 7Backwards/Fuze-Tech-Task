//
//  TweetsCollectionViewCell.swift
//  Fuze Tech Task
//
//  Created by Gonçalo Neves on 26/06/2021.
//

import UIKit

class TweetsCollectionViewCellModel {

    // MARK: Properties

    let cornerRadius: CGFloat = 10
    let shadowOpacity: Float = 0.8
    let shadowRadius: CGFloat = 2
    let shadowOffset: CGSize = CGSize(width: 1, height: 0)
    let outerConstraintConstant: CGFloat = 15
}

class TweetsCollectionViewCell: UICollectionViewCell {

    // MARK: Properties

    let viewModel = TweetsCollectionViewCellModel()

    // MARK: UI

    lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    lazy var horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "tweet content"
        label.numberOfLines = 0
        return label
    }()

    lazy var senderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "sender content"
        return label
    }()

    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "date content"
        label.textAlignment = .right
        return label
    }()

    // MARK: Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Private methods

    private func setupUI() {

        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = viewModel.shadowOffset
        layer.shadowRadius = viewModel.shadowRadius
        layer.shadowOpacity = viewModel.shadowOpacity
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
        layer.backgroundColor = UIColor.clear.cgColor

        layer.cornerRadius = viewModel.cornerRadius
        clipsToBounds = true


        addSubview(verticalStackView)
        verticalStackView.addArrangedSubview(contentLabel)
        verticalStackView.addArrangedSubview(horizontalStackView)
        horizontalStackView.addArrangedSubview(senderLabel)
        horizontalStackView.addArrangedSubview(dateLabel)

        NSLayoutConstraint.activate([
            verticalStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: viewModel.outerConstraintConstant),
            verticalStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -viewModel.outerConstraintConstant),
            verticalStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: viewModel.outerConstraintConstant),
            verticalStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -viewModel.outerConstraintConstant)
        ])
    }
}
