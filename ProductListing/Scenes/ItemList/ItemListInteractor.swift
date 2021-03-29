//
//  ItemListInteractor.swift
//  ProductListing
//
//  Created by Gökhan KOCA on 27.03.2021.
//

import CoreData
import UIKit

class ItemListInteractor {
	// MARK: - VIPER Stack
	weak var presenter: ItemListInteractorToPresenterInterface!
	
	// MARK: - Instance Variables
	
	// MARK: - Operational
	deinit {
		LOG("\(#function) \(String(describing: self))")
	}
}

// MARK: - Presenter To Interactor Interface
extension ItemListInteractor: ItemListPresenterToInteractorInterface {
	func fetchItems() {
		func loadFromRemote() {
			CartService.list.call(shoudShowLoading: false) { [weak self] (response: Products?, error) in
				guard let list = response?.products else {
					self?.presenter.didFail(errorText: error?.localizedDescription ?? "Unknown Error")
					return
				}
				self?.presenter.didFetched(items: list)
				let delegate = UIApplication.shared.delegate as? CoreDataCapable
				delegate?.saveContext()
			}
		}
		let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
		let sort = NSSortDescriptor(key: "id", ascending: true)
		fetchRequest.sortDescriptors = [sort]
		do {
			let delegate = UIApplication.shared.delegate as? CoreDataCapable
			let list: [Product] = try delegate?.persistentContainer.viewContext.fetch(fetchRequest) ?? []
			if list.isEmpty {
				loadFromRemote()
			} else {
				presenter.didFetched(items: list)
			}
		} catch {
			loadFromRemote()
		}
	}
}

// MARK: - Communication Interfaces
// VIPER Interface for communication from Interactor -> Presenter
protocol ItemListInteractorToPresenterInterface: class {
	func didFetched(items: [Product])
	func didFail(errorText: String)
}
