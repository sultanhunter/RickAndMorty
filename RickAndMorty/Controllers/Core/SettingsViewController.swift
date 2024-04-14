//
//  SettingsViewController.swift
//  RickAndMorty
//
//  Created by Sultan on 13/12/23.
//

import SafariServices
import StoreKit
import SwiftUI
import UIKit

final class SettingsViewController: UIViewController {
    private var settingsSwiftUIController: UIHostingController<SettingsView>?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = "Settings"
        addSwiftUIController()
    }

    private func addSwiftUIController() {
        let settingsSwiftUIController = UIHostingController(rootView: SettingsView(viewModel: SettingsViewVM(cellViewModels: SettingsOptions.allCases.compactMap {
            SettingsCellViewModel(type: $0) { [weak self] option in
                self?.handleTap(option: option)
            }
        })))

        addChild(settingsSwiftUIController)
        settingsSwiftUIController.didMove(toParent: self)
        view.addSubview(settingsSwiftUIController.view)
        settingsSwiftUIController.view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            settingsSwiftUIController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            settingsSwiftUIController.view.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            settingsSwiftUIController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            settingsSwiftUIController.view.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),

        ])

        self.settingsSwiftUIController = settingsSwiftUIController
    }

    private func handleTap(option: SettingsOptions) {
        guard Thread.current.isMainThread else { return }

        if let url = option.targetURL {
            let vc = SFSafariViewController(url: url)
            present(vc, animated: true)
        } else {
            if let windowScene = view.window?.windowScene {
                SKStoreReviewController.requestReview(in: windowScene)
            }
        }
    }
}
