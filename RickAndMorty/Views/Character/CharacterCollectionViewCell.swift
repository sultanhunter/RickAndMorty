//
//  CharacterCollectionViewCell.swift
//  RickAndMorty
//
//  Created by Sultan on 14/12/23.
//

import UIKit

final class CharacterCollectionViewCell: UICollectionViewCell {
    static let cellIdentifier = "CharacterCollectionViewCell"

    private var viewModel: CharacterCollectionViewCellVM?

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 8
        imageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let statusLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let statusIcon = CharacterStatusIcon()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubviews(imageView, nameLabel, statusLabel, statusIcon)
        addConstraints()
        setUpLayer()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }

    private func setUpLayer() {
        contentView.layer.cornerRadius = 8
        contentView.layer.shadowColor = UIColor.label.cgColor
        contentView.layer.shadowOffset = CGSize(width: -6, height: 6)
        contentView.layer.shadowOpacity = 0.15
    }

    private func addConstraints() {
        NSLayoutConstraint.activate([
            nameLabel.heightAnchor.constraint(equalToConstant: 30),
            nameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8),
            nameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8),
            nameLabel.bottomAnchor.constraint(equalTo: statusLabel.topAnchor),

            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            imageView.bottomAnchor.constraint(equalTo: nameLabel.topAnchor, constant: -3),

            statusIcon.heightAnchor.constraint(equalToConstant: 8),
            statusIcon.widthAnchor.constraint(equalToConstant: 8),
            statusIcon.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8),
            statusIcon.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -14),

            statusLabel.heightAnchor.constraint(equalToConstant: 30),
            statusLabel.leftAnchor.constraint(equalTo: statusIcon.rightAnchor, constant: 8),
            statusLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8),
            statusLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -3),

        ])
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setUpLayer()
        setStatusIconColor()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        nameLabel.text = nil
        statusLabel.text = nil
    }

    private func setStatusIconColor() {
        guard let viewModel = viewModel else { return }
        DispatchQueue.main.async { [weak self] in
            if viewModel.characterStatus.rawValue == "Alive" {
                self?.statusIcon.setColor(UIColor.green.cgColor)
            } else if viewModel.characterStatus.rawValue == "unknown" {
                self?.statusIcon.setColor(UIColor.brown.cgColor)
            } else {
                self?.statusIcon.setColor(UIColor.red.cgColor)
            }
        }
    }

    public func configure(with viewModel: CharacterCollectionViewCellVM) {
        self.viewModel = viewModel
        nameLabel.text = viewModel.characterName
        statusLabel.text = viewModel.characterStatusText
        setStatusIconColor()
        Task {
            do {
                guard let data = try await viewModel.fetchImage() else { return }
                DispatchQueue.main.async { [weak self] in
                    let image = UIImage(data: data)
                    self?.imageView.image = image
                }
            } catch {}
        }
    }
}
