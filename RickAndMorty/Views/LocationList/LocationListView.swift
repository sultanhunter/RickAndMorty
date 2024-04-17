//
//  LocationView.swift
//  RickAndMorty
//
//  Created by Sultan on 15/04/24.
//

import UIKit

protocol LocationListViewDelegate: AnyObject {
    func didSelectLocation(_ location: RMLocation)
}

final class LocationListView: UIView {
    public weak var delegate: LocationListViewDelegate?

    private let viewModel: LocationListViewVM

    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(LocationListViewTableCell.self, forCellReuseIdentifier: LocationListViewTableCell.cellIdentifier)
        table.alpha = 0
        table.isHidden = true
        return table
    }()

    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        return spinner
    }()

    init() {
        self.viewModel = LocationListViewVM()
        super.init(frame: .zero)
        viewModel.delegate = self

        backgroundColor = .systemBackground
        translatesAutoresizingMaskIntoConstraints = false

        addSubviews(tableView, spinner)
        spinner.startAnimating()
        addConstraints()
        configureTable()
        Task {
            await viewModel.fetchInitialLocations()
        }
    }

    private func reloadTableViewData() {
        spinner.stopAnimating()
        tableView.isHidden = false
        tableView.reloadData()
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.tableView.alpha = 1
        }
    }

    private func addConstraints() {
        NSLayoutConstraint.activate([
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),

            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: leftAnchor),
            tableView.rightAnchor.constraint(equalTo: rightAnchor),

        ])
    }

    private func configureTable() {
        tableView.delegate = viewModel
        tableView.dataSource = viewModel
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
}

extension LocationListView: LocationListViewVMDelegate {
    func didSelectLocation(_ location: RMLocation) {
        delegate?.didSelectLocation(location)
    }

    func didLoadInitialCharacters() {
        DispatchQueue.main.async { [weak self] in
            self?.reloadTableViewData()
        }
    }
}
