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

    let sections = [
        Section(),
        Section(title: "Second"),
		Section()
    ]

    let items = [
        [
            "First",
            "Second",
            "Third"
        ],
        [
            "First",
            "Second",
            "Third"
        ],
        [
            "First",
            "Second",
            "Third"
        ],
    ].map({ $0.map({ Item(text: $0) }) })

    var snapshot: NSDiffableDataSourceSnapshot<Section, Item> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()

        zip(sections, items).forEach { section, items in
            snapshot.appendSections([section])
            snapshot.appendItems(items, toSection: section)
        }

        return snapshot
    }

	var footer: String {
		"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat."
	}

}
