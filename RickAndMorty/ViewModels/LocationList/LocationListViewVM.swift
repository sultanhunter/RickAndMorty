//
//  LocationViewVM.swift
//  RickAndMorty
//
//  Created by Sultan on 15/04/24.
//

import UIKit

protocol LocationListViewVMDelegate: AnyObject {
    func didLoadInitialCharacters()
    func didSelectLocation(_ location: RMLocation)
}

final class LocationListViewVM: NSObject {
    public weak var delegate: LocationListViewVMDelegate?

    private var locations: [RMLocation] = [] {
        didSet {
            for location in locations {
                let viewModel = LocationListViewTableCellVM(location: location)
                if !cellViewModels.contains(viewModel) {
                    cellViewModels.append(viewModel)
                }
            }
        }
    }

    private var apiInfo: AllLoactionsResponseInfo?

    private var cellViewModels: [LocationListViewTableCellVM] = []

    public func fetchInitialLocations() async {
        do {
            let request = ApiRequest(endpoint: .location)
            let response = try await ApiService.shared.execute(request, expecting: RMAllLoactionsResponse.self)
            apiInfo = response.info
            locations = response.results
            delegate?.didLoadInitialCharacters()
        } catch {}
    }

    private var hasMoreResult: Bool {
        return false
    }
}

extension LocationListViewVM: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellViewModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LocationListViewTableCell.cellIdentifier, for: indexPath) as? LocationListViewTableCell else {
            fatalError()
        }
        let viewModel = cellViewModels[indexPath.row]
        cell.configure(with: viewModel)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let index = indexPath.row
        guard index >= 0 && index < locations.count else {
            return
        }
        let location = locations[index]
        delegate?.didSelectLocation(location)
    }
}
