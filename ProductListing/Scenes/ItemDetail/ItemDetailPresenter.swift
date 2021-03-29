//
//  ItemDetailPresenter.swift
//  ProductListing
//
//  Created by Gökhan KOCA on 27.03.2021.
//

import Foundation

class ItemDetailPresenter {
	// MARK: - VIPER Stack
	weak var interactor: ItemDetailPresenterToInteractorInterface!
	weak var view: ItemDetailPresenterToViewInterface!
	weak var wireframe: ItemDetailPresenterToWireframeInterface!
	
	// MARK: - Instance Variables
	weak var delegate: ItemDetailDelegate?
	var moduleWireframe: ItemDetail {
		get {
			let mw = (self.wireframe as? ItemDetail)!
			return mw
		}
	}
	var itemId: String
	var item: ProductDetail!
	
	// MARK: - Operational
	init(with id: String) {
		self.itemId = id
	}
	
	deinit {
		LOG("\(#function) \(String(describing: self))")
	}
}

// MARK: - Interactor to Presenter Interface
extension ItemDetailPresenter: ItemDetailInteractorToPresenterInterface {
	func didFetched(item: ProductDetail) {
		self.item = item
		view.didLoad(item: item)
		wireframe.didLoadScene()
	}
	
	func didFail(errorText: String) {
		LOG(level: .error, errorText)
	}
}

// MARK: - View to Presenter Interface
extension ItemDetailPresenter: ItemDetailViewToPresenterInterface {
	func viewDidDisappear() {
		delegate?.moduleShouldDispose()
	}
}

// MARK: - Wireframe to Presenter Interface
extension ItemDetailPresenter: ItemDetailWireframeToPresenterInterface {
	func loadItem() {
		interactor.fetchItem(with: itemId)
	}
	
	func set(delegate newDelegate: ItemDetailDelegate?) {
		delegate = newDelegate
	}
}

// MARK: - Communication Interfaces
// VIPER Interface to the Module
protocol ItemDetailDelegate: class {
	func moduleShouldDispose()
}

// VIPER Interface for communication from Presenter to Interactor
protocol ItemDetailPresenterToInteractorInterface: class {
	func fetchItem(with id: String)
}

// VIPER Interface for communication from Presenter -> Wireframe
protocol ItemDetailPresenterToWireframeInterface: class {
	func didLoadScene()
}

// VIPER Interface for communication from Presenter -> View
protocol ItemDetailPresenterToViewInterface: class {
	func didLoad(item: ProductDetail)
}
