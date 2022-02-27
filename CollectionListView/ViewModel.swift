//
//  ViewModel.swift
//  CollectionListView
//
//  Created by Balázs Szamódy on 27/2/2022.
//

import Foundation
import UIKit

class ViewModel {
    struct Section: Hashable {
        var id = UUID()
        var title: String?
    }

    struct Item: Hashable {
        var id = UUID()
        var text: String
    }

    let items: [Section: [Item]] = [
        Section(title: "First") : [
            "First",
            "Second",
            "Third"
        ]
    ].mapValues({ $0.map({ Item(text: $0) }) })

    var snapshot: NSDiffableDataSourceSnapshot<Section, Item> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()

        items.forEach { section, items in
            snapshot.appendSections([section])
            snapshot.appendItems(items, toSection: section)
        }

        return snapshot
    }

}
