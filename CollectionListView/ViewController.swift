//
//  ViewController.swift
//  CollectionListView
//
//  Created by Balázs Szamódy on 27/2/2022.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    typealias Section = ViewModel.Section
    typealias Item = ViewModel.Item

    private lazy var collectionView: UICollectionView = buildCollectionView()
    private lazy var dataSource: UICollectionViewDiffableDataSource<Section, Item> = buildDataSource()

    var viewModel: ViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        buildView()
        buildLayout()

        dataSource.apply(viewModel.snapshot, animatingDifferences: false)
    }

    // MARK: - View setup

    private func buildView() {
        view.addSubview(collectionView)

        title = "Collection view list"
    }

    private func buildLayout() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    // MARK: - CollectionView setup

    private func buildCollectionView() -> UICollectionView {
        var config = UICollectionLayoutListConfiguration(appearance: .plain)
        config.headerMode = .supplementary
        config.footerMode = .supplementary
        
        let layout = UICollectionViewCompositionalLayout.list(using: config)

        return UICollectionView.init(frame: .zero, collectionViewLayout: layout)
    }

    private func buildDataSource() -> UICollectionViewDiffableDataSource<Section, Item> {
        let cellRegistration = buildCellRegistration()
        let headerRegistration = buildHeaderRegistration()
        let footerRegistration = buildFooterRegistration()

        let dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        }

        dataSource.supplementaryViewProvider = { collectionView, elementKind, indexPath in
            if elementKind == UICollectionView.elementKindSectionHeader {
            return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
            } else {
                return collectionView.dequeueConfiguredReusableSupplementary(using: footerRegistration, for: indexPath)
            }
        }

        return dataSource
    }

    private func buildCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewListCell, Item> {
        UICollectionView.CellRegistration { cell, _, itemIdentifier in
            var contentConfig = cell.defaultContentConfiguration()
            contentConfig.text = itemIdentifier.text
            cell.contentConfiguration = contentConfig
        }
    }

    private func buildHeaderRegistration() -> UICollectionView.SupplementaryRegistration<UICollectionViewListCell> {
        UICollectionView.SupplementaryRegistration(elementKind: UICollectionView.elementKindSectionHeader) { [weak self] supplementaryView, _, indexPath in
            guard let self = self else {
                return
            }

            let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]

            var contentConfig = supplementaryView.defaultContentConfiguration()
            contentConfig.text = section.title
            supplementaryView.contentConfiguration = contentConfig
        }
    }

    private func buildFooterRegistration() -> UICollectionView.SupplementaryRegistration<UICollectionViewListCell> {
        UICollectionView.SupplementaryRegistration(elementKind: UICollectionView.elementKindSectionFooter) { [weak self] supplementaryView, _, indexPath in
			var config = supplementaryView.defaultContentConfiguration()

			if let sectionCount = self?.dataSource.snapshot().sectionIdentifiers.count, indexPath.section == sectionCount - 1 {
				// Add footer for last section
				config.text = self?.viewModel.footer
				config.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: 16, trailing: 0)
			} else {
				config.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: 0, trailing: 0)
			}

            supplementaryView.contentConfiguration = config
        }
    }

}

