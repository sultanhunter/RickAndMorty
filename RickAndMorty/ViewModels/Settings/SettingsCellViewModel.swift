//
//  SettingsCellViewModels.swift
//  RickAndMorty
//
//  Created by Sultan on 14/04/24.
//

import UIKit

struct SettingsCellViewModel: Identifiable {
    let id: String

    public let type: SettingsOptions
    public let onTapHandler: (SettingsOptions) -> Void

    public var image: UIImage? {
        type.iconImage
    }

    public var title: String {
        type.displayTitle
    }

    public var iconColor: UIColor {
        type.iconContainerColor
    }

    init(type: SettingsOptions, onTapHandler: @escaping (SettingsOptions) -> Void) {
        self.type = type
        self.id = type.displayTitle
        self.onTapHandler = onTapHandler
    }
}
