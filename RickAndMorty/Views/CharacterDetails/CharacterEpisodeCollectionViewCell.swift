//
//  CharacterEpisodeCollectionViewCell.swift
//  RickAndMorty
//
//  Created by Sultan on 06/04/24.
//

import UIKit

final class CharacterEpisodeCollectionViewCell: UICollectionViewCell {
    static let cellIdentifier = "CharacterEpisodeCollectionViewCell"

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    private func setupConstraints() {}

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    public func configure(with withViewModel: CharacterEpisodeCollectionViewCellVM) {}
}
