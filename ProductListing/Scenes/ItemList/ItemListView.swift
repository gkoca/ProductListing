//
//  ItemListView.swift
//  ProductListing
//
//  Created by Gökhan KOCA on 27.03.2021.
//

import UIKit

class ItemListView: UIViewController {
	// MARK: - VIPER Stack
	weak var presenter: ItemListViewToPresenterInterface!
	
	// MARK: - Instance Variables
	private lazy var gridLayout: UICollectionViewFlowLayout = {
		let collectionFlowLayout = UICollectionViewFlowLayout()
		collectionFlowLayout.scrollDirection = .vertical
		collectionFlowLayout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 0, right: 8)
		let side = (UIScreen.main.bounds.width - 32) / 2
		collectionFlowLayout.itemSize = CGSize(width: side, height: side)
		collectionFlowLayout.minimumInteritemSpacing = 0
		collectionFlowLayout.minimumLineSpacing = 16
		return collectionFlowLayout
	}()
	
	// MARK: - Outlets
	@IBOutlet weak var collectionView: UICollectionView!
	
	// MARK: - Operational
	
	override func viewDidLoad() {
		setupUI()
	}
	
	func setupUI() {
		title = "Products"
		collectionView.delegate = self
		collectionView.dataSource = self
		collectionView.register(UINib(nibName: "ProductCollectionViewCell", bundle: nil),
								forCellWithReuseIdentifier: "productCell")
		collectionView.setCollectionViewLayout(gridLayout, animated: false)
	}
	
	deinit {
		LOG("\(#function) \(String(describing: self))")
	}
}

extension ItemListView: UICollectionViewDelegate, UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		presenter.products.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productCell", for: indexPath) as? ProductCollectionViewCell else {
			return UICollectionViewCell()
		}
		let product = presenter.products[indexPath.row]
		cell.nameLabel.text = product.name
		cell.priceLabel.text = String(format: "%.2f", product.price)
		cell.imageView.load(from: product.image ?? "", contentMode: .scaleAspectFill, placeholder: "placeholderImage")
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {	
		presenter.didSelectItem(at: indexPath.row)
		collectionView.deselectItem(at: indexPath, animated: true)
	}
}

// MARK: - Navigation Interface
extension ItemListView: ItemListNavigationInterface {

}

// MARK: - Presenter to View Interface
extension ItemListView: ItemListPresenterToViewInterface {
	func didLoad(items: [Product]) {
		collectionView.reloadData()
	}
}

// MARK: - Communication Interfaces
// VIPER Interface for communication from View -> Presenter
protocol ItemListViewToPresenterInterface: class {
	var products: [Product] { get }
	func didSelectItem(at index: Int)
}
