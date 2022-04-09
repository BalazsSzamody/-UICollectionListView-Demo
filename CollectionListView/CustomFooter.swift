//
//  CustomFooter.swift
//  CollectionListView
//
//  Created by Balázs Szamódy on 9/4/2022.
//

import UIKit
import SnapKit

struct CustomFooterContentConfiguration: UIContentConfiguration {

	var text: String?
	var directionalLayoutMargins: NSDirectionalEdgeInsets = .zero
	var font: UIFont?

	func makeContentView() -> UIView & UIContentView {
		CustomFooter(configuration: self)
	}

	func updated(for state: UIConfigurationState) -> CustomFooterContentConfiguration {
		self
	}

}

class CustomFooter: UIView, UIContentView {

	lazy var label: UILabel = {
		let label = UILabel()
		label.numberOfLines = 0
		return label
	}()

	var topConstraint: Constraint?
	var bottomConstraint: Constraint?
	var leadingConstraint: Constraint?
	var trailingConstraint: Constraint?

	var configuration: UIContentConfiguration {
		didSet {
			configure(with: configuration as? CustomFooterContentConfiguration)
		}
	}

	init(frame: CGRect = .zero, configuration: CustomFooterContentConfiguration = CustomFooterContentConfiguration()) {
		self.configuration = configuration
		super.init(frame: frame)

		buildView()
		buildLayout()
		configure(with: configuration)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func buildView() {
		addSubview(label)
	}

	private func buildLayout() {
		label.snp.makeConstraints { make in
			topConstraint = make.top.equalToSuperview().constraint
			bottomConstraint = make.bottom.equalToSuperview().constraint
			leadingConstraint = make.leading.equalToSuperview().constraint
			trailingConstraint = make.trailing.equalToSuperview().constraint
		}
	}

	private func configure(with configuration: CustomFooterContentConfiguration?) {
		guard let configuration = configuration else {
			return
		}

		label.text = configuration.text

		if let font = configuration.font {
			label.font = font
		}

		topConstraint?.update(inset: configuration.directionalLayoutMargins.top)
		bottomConstraint?.update(inset: configuration.directionalLayoutMargins.bottom)
		leadingConstraint?.update(inset: configuration.directionalLayoutMargins.leading)
		trailingConstraint?.update(inset: configuration.directionalLayoutMargins.trailing)
	}
}

extension UIListContentConfiguration {
	static func customFooterConfiguration() -> CustomFooterContentConfiguration {
		CustomFooterContentConfiguration()
	}
}
