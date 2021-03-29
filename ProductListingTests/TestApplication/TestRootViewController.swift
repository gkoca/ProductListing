//
//  TestRootViewController.swift
//  ProductListingTests
//
//  Created by Gökhan KOCA on 27.03.2021.
//

import UIKit

final class TestRootViewController: UIViewController {
	override func loadView() {
		let label = UILabel()
		label.text = "Running Unit Tests..."
		label.textAlignment = .center
		label.textColor = .white
		view = label
	}
}
