//
//  CharacterDetailViewController.swift
//  RickAndMorty
//
//  Created by Sultan on 15/12/23.
//

import UIKit

final class CharacterDetailViewController: UIViewController {
    private let viewModel: CharacterDetailViewVM
    init(viewModel: CharacterDetailViewVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = viewModel.title
    }
}
