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
        var config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        config.headerMode = .supplementary
        config.footerMode = .supplementary
		config.backgroundColor = .systemGray5
		if #available(iOS 14.5, *) {
			config.separatorConfiguration.color = .systemOrange
		}
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
			contentConfig.textProperties.color = .systemOrange

			// Image
			contentConfig.image = UIImage(systemName: "flame.circle.fill")
			contentConfig.imageProperties.tintColor = .systemOrange

            cell.contentConfiguration = contentConfig

			// Background
			cell.backgroundConfiguration?.backgroundColor = .systemOrange.withAlphaComponent(0.15)
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
			// Change font
			contentConfig.textProperties.font = .preferredFont(forTextStyle: .headline)

            supplementaryView.contentConfiguration = contentConfig
        }
    }

    private func buildFooterRegistration() -> UICollectionView.SupplementaryRegistration<UICollectionViewListCell> {
        UICollectionView.SupplementaryRegistration(elementKind: UICollectionView.elementKindSectionFooter) { [weak self] supplementaryView, _, indexPath in

			if let sectionCount = self?.dataSource.snapshot().sectionIdentifiers.count, indexPath.section == sectionCount - 1 {
				// Add footer for last section
				var config = UIListContentConfiguration.customFooterConfiguration()
				config.text = self?.viewModel.footer
				config.font = .preferredFont(forTextStyle: .footnote)
				config.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 24, leading: 0, bottom: 16, trailing: 0)
				supplementaryView.contentConfiguration = config
			} else {
				var config = supplementaryView.defaultContentConfiguration()
				config.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: 0, trailing: 0)
				supplementaryView.contentConfiguration = config
			}


        }
    }

}

