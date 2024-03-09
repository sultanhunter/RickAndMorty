//
//  CharacterListVVM.swift
//  RickAndMorty
//
//  Created by Sultan on 14/12/23.
//

import UIKit

protocol CharacterListViewVMDelegate: AnyObject {
    func didLoadInitialCharacters()
    func didLoadMoreCharacters(with newIndexPaths: [IndexPath])
    func didSelectCharacter(_ character: RMCharacter)
}

final class CharacterListViewVM: NSObject {
    public weak var delegate: CharacterListViewVMDelegate?

    private var isLoadingMoreCharacters = false

    public var characters: [RMCharacter] = [] {
        didSet {
            for character in characters {
                let viewModel = CharacterCollectionViewCellVM(characterId: character.id, characterName: character.name, characterStatus: character.status, characterImageUrl: URL(string: character.image))

                if !cellViewModels.contains(viewModel) {
                    cellViewModels.append(viewModel)
                }
            }
        }
    }

    private var cellViewModels: [CharacterCollectionViewCellVM] = []

    private var apiInfo: AllCharactersResponseInfo? = nil

    public func fetchInitialCharacterList() async {
        do {
            let allCharactersResponse = try await ApiService.shared.execute(.listCharactersRequest, expecting: RMAllCharactersResponse.self)
            characters = allCharactersResponse.results
            apiInfo = allCharactersResponse.info
            DispatchQueue.main.async { [weak self] in
                self?.delegate?.didLoadInitialCharacters()
            }
        } catch {
            print(error)
        }
    }

    public func fetchAdditionalCharacters(url: URL) async {
        guard !isLoadingMoreCharacters else { return }
        print("Fetching more characters")
        isLoadingMoreCharacters = true
        do {
            guard let request = ApiRequest(url: url) else {
                isLoadingMoreCharacters = false
                return
            }
            let allCharactersResponse = try await ApiService.shared.execute(request, expecting: RMAllCharactersResponse.self)
            let newCharacters = allCharactersResponse.results

            let originalCount = characters.count
            let newCount = newCharacters.count
            let totalCount = originalCount + newCount
            let startingIndex = totalCount - newCount

            let indexPathsToAdd: [IndexPath] = Array(startingIndex ..< (startingIndex + newCount)).compactMap {
                IndexPath(row: $0, section: 0)
            }
            apiInfo = allCharactersResponse.info
            characters.append(contentsOf: allCharactersResponse.results)

            DispatchQueue.main.async { [weak self] in
                self?.delegate?.didLoadMoreCharacters(with: indexPathsToAdd)
                self?.isLoadingMoreCharacters = false
            }
        } catch {
            isLoadingMoreCharacters = false
        }
    }

    public var shouldShowLoadMoreIndicator: Bool {
        return apiInfo?.next != nil
    }
}

extension CharacterListViewVM: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    /// setting cells count
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellViewModels.count
    }

    /// Configuring Cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterCollectionViewCell.cellIdentifier, for: indexPath) as? CharacterCollectionViewCell else { fatalError("Unsupported cell") }

        let viewModel = cellViewModels[indexPath.row]
        cell.configure(with: viewModel)
        return cell
    }

    // Sizing cell function
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = collectionView.bounds
        let collectionViewHeight = bounds.height
        let cellWidth = (bounds.width - 30) / 2

        let maxCellHeight = cellWidth * 1.5
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
        let character = characters[indexPath.row]
        delegate?.didSelectCharacter(character)
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

extension CharacterListViewVM: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard shouldShowLoadMoreIndicator, !isLoadingMoreCharacters,!cellViewModels.isEmpty, let urlString = apiInfo?.next, let url = URL(string: urlString) else { return }

        let offset = scrollView.contentOffset.y
        let totalContentHeight = scrollView.contentSize.height
        let scrollViewContainerHeight = scrollView.frame.size.height

        if offset >= totalContentHeight - scrollViewContainerHeight - 120 {
            Task {
                [weak self] in
                guard let self = self else { return }
                await self.fetchAdditionalCharacters(url: url)
            }
        }
    }
}
