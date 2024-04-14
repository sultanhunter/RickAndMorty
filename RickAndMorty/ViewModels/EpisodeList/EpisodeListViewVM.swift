//
//  EpisodeListViewVM.swift
//  RickAndMorty
//
//  Created by Sultan on 07/04/24.
//

import UIKit

protocol EpisodeListViewVMDelegate: AnyObject {
    func didLoadInitialCharacters()
    func didLoadMoreEpisodes(with newIndexPaths: [IndexPath])
    func didSelectEpisode(_ episode: RMEpisode)
}

final class EpisodeListViewVM: NSObject {
    public weak var delegate: EpisodeListViewVMDelegate?

    private var isLoadingMoreEpisodes = false

    private let borderColors: [UIColor] = [
        .systemGreen,
        .systemBlue,
        .systemOrange,
        .systemPink,
        .systemPurple,
        .systemRed,
        .systemYellow,
        .systemMint,
        .systemTeal
    ]

    public var episodes: [RMEpisode] = [] {
        didSet {
            for episode in episodes {
                let viewModel = CharacterEpisodeCollectionViewCellVM(episodeDatatUrl: URL(string: episode.url), borderColor: borderColors.randomElement() ?? .systemTeal)

                if !cellViewModels.contains(viewModel) {
                    cellViewModels.append(viewModel)
                }
            }
        }
    }

    private var cellViewModels: [CharacterEpisodeCollectionViewCellVM] = []

    private var apiInfo: AllEpisodesResponseInfo?

    public func fetchInitialEpisodesList() async {
        do {
            let allEpisodesResponse = try await ApiService.shared.execute(.listEpisodeRequest, expecting: RMAllEpisodesResponse.self)
            episodes = allEpisodesResponse.results
            apiInfo = allEpisodesResponse.info
            delegate?.didLoadInitialCharacters()
        } catch {
            print(error)
        }
    }

    public func fetchAdditionalEpisodes(url: URL) async {
        guard !isLoadingMoreEpisodes else { return }
        print("Fetching more epiosded")
        isLoadingMoreEpisodes = true
        do {
            guard let request = ApiRequest(url: url) else {
                isLoadingMoreEpisodes = false
                return
            }
            let allEpisodesResponse = try await ApiService.shared.execute(request, expecting: RMAllEpisodesResponse.self)
            let newEpisodes = allEpisodesResponse.results

            let originalCount = episodes.count
            let newCount = newEpisodes.count
            let totalCount = originalCount + newCount
            let startingIndex = totalCount - newCount

            let indexPathsToAdd: [IndexPath] = Array(startingIndex ..< (startingIndex + newCount)).compactMap {
                IndexPath(row: $0, section: 0)
            }
            apiInfo = allEpisodesResponse.info
            episodes.append(contentsOf: allEpisodesResponse.results)

            delegate?.didLoadMoreEpisodes(with: indexPathsToAdd)
            isLoadingMoreEpisodes = false
        } catch {
            isLoadingMoreEpisodes = false
        }
    }

    public var shouldShowLoadMoreIndicator: Bool {
        return apiInfo?.next != nil
    }
}

extension EpisodeListViewVM: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    /// setting cells count
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellViewModels.count
    }

    /// Configuring Cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterEpisodeCollectionViewCell.cellIdentifier, for: indexPath) as? CharacterEpisodeCollectionViewCell else { fatalError("Unsupported cell") }

        let viewModel = cellViewModels[indexPath.row]
        cell.configure(with: viewModel)
        return cell
    }

    // Sizing cell function
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = collectionView.bounds
        let collectionViewHeight = bounds.height
        let cellWidth = bounds.width - 20

        let maxCellHeight = 100.0
        let cellHeight = maxCellHeight >= collectionViewHeight ? collectionViewHeight - 20 : maxCellHeight
        return CGSize(width: cellWidth, height: cellHeight)
    }

    /// Padding function
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }

    /// Line Spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }

    /// Selecting an Item
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let episode = episodes[indexPath.row]
        delegate?.didSelectEpisode(episode)
    }

    /// Setting Footer Loader
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionFooter, shouldShowLoadMoreIndicator else {
            return UICollectionReusableView()
        }

        guard let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: FooterLoadingCollectionReusableView.indentifier, for: indexPath) as? FooterLoadingCollectionReusableView
        else {
            fatalError("Unsupported")
        }
        footer.startAnimating()
        return footer
    }

    /// Footer Loader Size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        guard shouldShowLoadMoreIndicator else {
            return .zero
        }
        return CGSize(width: collectionView.frame.width, height: 100)
    }
}

extension EpisodeListViewVM: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard shouldShowLoadMoreIndicator, !isLoadingMoreEpisodes,!cellViewModels.isEmpty, let urlString = apiInfo?.next, let url = URL(string: urlString) else { return }

        let offset = scrollView.contentOffset.y
        let totalContentHeight = scrollView.contentSize.height
        let scrollViewContainerHeight = scrollView.frame.size.height

        if offset >= totalContentHeight - scrollViewContainerHeight - 120 {
            Task {
                [weak self] in
                guard let self = self else { return }
                await self.fetchAdditionalEpisodes(url: url)
            }
        }
    }
}
