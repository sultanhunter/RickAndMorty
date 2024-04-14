//
//  SettingsViewVM.swift
//  RickAndMorty
//
//  Created by Sultan on 14/04/24.
//

import UIKit

struct SettingsViewVM {
    let cellViewModels: [SettingsCellViewModel]
}

enum SettingsOptions: CaseIterable {
    case rateApp
    case contactUs
    case terms
    case privacy
    case apiReference
    case viewCode

    var targetURL: URL? {
        switch self {
        case .rateApp:
            return nil
        case .contactUs:
            return URL(string: "https://github.com/sultanhunter")
        case .terms:
            return URL(string: "https://github.com/sultanhunter")
        case .privacy:
            return URL(string: "https://github.com/sultanhunter")
        case .apiReference:
            return URL(string: "https://rickandmortyapi.com")
        case .viewCode:
            return URL(string: "https://github.com/sultanhunter/RickAndMorty")
        }
    }

    var displayTitle: String {
        switch self {
        case .rateApp:
            return "Rate App"
        case .contactUs:
            return "Contact Us"
        case .terms:
            return "Terms of Service"
        case .privacy:
            return "Privacy Policy"
        case .apiReference:
            return "API Reference"
        case .viewCode:
            return "Github Link"
        }
    }

    var iconContainerColor: UIColor {
        switch self {
        case .rateApp:
            return .systemBlue
        case .contactUs:
            return .systemGreen
        case .terms:
            return .systemOrange
        case .privacy:
            return .systemYellow
        case .apiReference:
            return .systemTeal
        case .viewCode:
            return .systemBrown
        }
    }

    var iconImage: UIImage? {
        switch self {
        case .rateApp:
            return UIImage(systemName: "star.fill")
        case .contactUs:
            return UIImage(systemName: "paperplane")
        case .terms:
            return UIImage(systemName: "doc")
        case .privacy:
            return UIImage(systemName: "lock")
        case .apiReference:
            return UIImage(systemName: "list.clipboard")
        case .viewCode:
            return UIImage(systemName: "hammer.fill")
        }
    }
}
