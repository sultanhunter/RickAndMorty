//
//  LocationListViewCellVM.swift
//  RickAndMorty
//
//  Created by Sultan on 15/04/24.
//

import Foundation

final class LocationListViewTableCellVM: Equatable {
    static func == (lhs: LocationListViewTableCellVM, rhs: LocationListViewTableCellVM) -> Bool {
        lhs.location.id == rhs.location.id
    }

    private let location: RMLocation

    public var name: String {
        location.name
    }

    public var type: String {
        "Type: " + location.type
    }

    public var dimension: String {
        location.dimension
    }

    init(location: RMLocation) {
        self.location = location
    }
}
