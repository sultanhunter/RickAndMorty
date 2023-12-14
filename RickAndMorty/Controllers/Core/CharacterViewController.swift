//
//  RMCharacterViewController.swift
//  RickAndMorty
//
//  Created by Sultan on 13/12/23.
//

import UIKit

final class CharacterViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = "Characters"
        Task {
            await fireApiCall()
        }
    }

    private func fireApiCall() async {
        let request = ApiRequest(endpoint: .character, pathComponents: ["1"], queryParameters: [
            URLQueryItem(name: "name", value: "rick"),
            URLQueryItem(name: "status", value: "alive")
        ])
        do {
            let character = try await ApiService.shared.execute(request, expecting: RMCharacter.self)
        } catch {}
    }
}
