//
//  ItemDetailView.swift
//  ProductListing
//
//  Created by Gökhan KOCA on 27.03.2021.
//

import UIKit

class ItemDetailView: UIViewController {
	// MARK: - VIPER Stack
	weak var presenter: ItemDetailViewToPresenterInterface!
	
	// MARK: - Instance Variables
	
	// MARK: - Outlets
	
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var priceLabel: UILabel!
	@IBOutlet weak var descriptionLabel: UILabel!
	
	// MARK: - Operational
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		presenter.viewDidDisappear()
	}
	
	deinit {
		LOG("\(#function) \(String(describing: self))")
	}
}

// MARK: - Navigation Interface
extension ItemDetailView: ItemDetailNavigationInterface { }

// MARK: - Presenter to View Interface
extension ItemDetailView: ItemDetailPresenterToViewInterface {
	func didLoad(item: ProductDetail) {
		self.title = item.name
		nameLabel.text = item.name
		imageView.load(from: item.image ?? "", contentMode: .scaleAspectFill, placeholder: "placeholderImage")
		priceLabel.text = String(format: "%.2f", item.price)
		descriptionLabel.text = item.desc
	}
}

// MARK: - Communication Interfaces
// VIPER Interface for communication from View -> Presenter
protocol ItemDetailViewToPresenterInterface: class {
	var item: ProductDetail! { get }
	func viewDidDisappear()
}
