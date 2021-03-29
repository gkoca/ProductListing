//
//  ItemDetailInteractor.swift
//  ProductListing
//
//  Created by Gökhan KOCA on 27.03.2021.
//

import UIKit
import CoreData

class ItemDetailInteractor {
	// MARK: - VIPER Stack
	weak var presenter: ItemDetailInteractorToPresenterInterface!
	
	// MARK: - Instance Variables
	
	// MARK: - Operational
	deinit {
		LOG("\(#function) \(String(describing: self))")
	}
}

// MARK: - Presenter To Interactor Interface
extension ItemDetailInteractor: ItemDetailPresenterToInteractorInterface {
	func fetchItem(with id: String) {
		func loadFromRemote(with id: String) {
			CartService.detail(id: id).call { [weak self] (response: ProductDetail?, error) in
				guard let item = response else {
					self?.presenter.didFail(errorText: error?.localizedDescription ?? "Unknown Error")
					return
				}
				self?.presenter.didFetched(item: item)
				let delegate = UIApplication.shared.delegate as? CoreDataCapable
				delegate?.saveContext()
			}
		}
		let delegate = UIApplication.shared.delegate as? CoreDataCapable
		let fetchRequest: NSFetchRequest<ProductDetail> = ProductDetail.fetchRequest(with: id)
		if let item = try? delegate?.persistentContainer.viewContext.fetch(fetchRequest).first {
			presenter.didFetched(item: item)
		} else {
			loadFromRemote(with: id)
		}
	}
}

// MARK: - Communication Interfaces
// VIPER Interface for communication from Interactor -> Presenter
protocol ItemDetailInteractorToPresenterInterface: class {
	func didFetched(item: ProductDetail)
	func didFail(errorText: String)
}
