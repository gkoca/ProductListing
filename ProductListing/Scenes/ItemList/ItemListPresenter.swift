//
//  ItemListPresenter.swift
//  ProductListing
//
//  Created by Gökhan KOCA on 27.03.2021.
//

import Foundation

class ItemListPresenter {
	// MARK: - VIPER Stack
	weak var interactor: ItemListPresenterToInteractorInterface!
	weak var view: ItemListPresenterToViewInterface!
	weak var wireframe: ItemListPresenterToWireframeInterface!
	
	// MARK: - Instance Variables
	weak var delegate: ItemListDelegate?
	var moduleWireframe: ItemList {
		get {
			let mw = (self.wireframe as? ItemList)!
			return mw
		}
	}
	var products: [Product] = []
	
	// MARK: - Operational
	deinit {
		LOG("\(#function) \(String(describing: self))")
	}
}

// MARK: - Interactor to Presenter Interface
extension ItemListPresenter: ItemListInteractorToPresenterInterface {
	func didFail(errorText: String) {
		LOG(level: .error, errorText)
	}
	
	func didFetched(items: [Product]) {
		products = items
		view.didLoad(items: items)
		wireframe.didLoadScene()
	}
}

// MARK: - View to Presenter Interface
extension ItemListPresenter: ItemListViewToPresenterInterface {
	func didSelectItem(at index: Int) {
		if let id = products[index].id {
			wireframe.gotoDetail(with: id)
		}
	}
}

// MARK: - Wireframe to Presenter Interface
extension ItemListPresenter: ItemListWireframeToPresenterInterface {
	func set(delegate newDelegate: ItemListDelegate?) {
		delegate = newDelegate
	}
	func loadItems() {
		interactor.fetchItems()
	}
}

// MARK: - Communication Interfaces
// VIPER Interface to the Module
protocol ItemListDelegate: class {
	
}

// VIPER Interface for communication from Presenter to Interactor
protocol ItemListPresenterToInteractorInterface: class {
	func fetchItems()
}

// VIPER Interface for communication from Presenter -> Wireframe
protocol ItemListPresenterToWireframeInterface: class {
	func didLoadScene()
	func gotoDetail(with id: String)
}

// VIPER Interface for communication from Presenter -> View
protocol ItemListPresenterToViewInterface: class {
	func didLoad(items: [Product])
}
