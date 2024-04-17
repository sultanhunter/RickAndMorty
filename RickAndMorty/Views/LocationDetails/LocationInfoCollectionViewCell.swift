//
//  EpisodeInfoCollectionViewCell.swift
//  RickAndMorty
//
//  Created by Sultan on 12/04/24.
//

import UIKit

final class LocationInfoCollectionViewCell: UICollectionViewCell {
    static let cellIdentifier = "LocationInfoCollectionViewCell"

    private var viewModel: LocationInfoCollectionViewCellVM?

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.textAlignment = .right
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubviews(titleLabel, valueLabel)
        setUpLayer()
        addConstraints()
    }

    private func addConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),

            valueLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5),
            valueLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            valueLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            valueLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),

        ])
    }

    private func setUpLayer() {
        layer.cornerRadius = 8
        layer.masksToBounds = true
        layer.borderWidth = 1
        layer.borderColor = UIColor.secondaryLabel.cgColor
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        valueLabel.text = nil
    }

    public func configure(with viewModel: LocationInfoCollectionViewCellVM) {
        self.viewModel = viewModel
        titleLabel.text = viewModel.title
        valueLabel.text = viewModel.value
    }
}
