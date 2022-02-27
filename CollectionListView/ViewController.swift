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

        let layout = UICollectionViewCompositionalLayout.list(using: config)

        return UICollectionView.init(frame: .zero, collectionViewLayout: layout)
    }

    private func buildDataSource() -> UICollectionViewDiffableDataSource<Section, Item> {
        let cellRegistration = buildCellRegistration()
        return UICollectionViewDiffableDataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        }
    }

    private func buildCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewListCell, Item> {
        UICollectionView.CellRegistration { cell, _, itemIdentifier in
            var contentConfig = cell.defaultContentConfiguration()
            contentConfig.text = itemIdentifier.text
            cell.contentConfiguration = contentConfig
        }
    }

}

