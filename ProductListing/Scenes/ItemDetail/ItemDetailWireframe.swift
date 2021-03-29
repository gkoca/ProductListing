//
//  ItemDetailWireframe.swift
//  ProductListing
//
//  Created by Gökhan KOCA on 27.03.2021.
//

import UIKit

class ItemDetailWireframe {
	// MARK: - VIPER Stack
	lazy var moduleInteractor = ItemDetailInteractor()
	var modulePresenter: ItemDetailPresenter
	lazy var moduleView: ItemDetailView = {
		
		let sb = ItemDetailWireframe.storyboard()
		let vc = (sb.instantiateViewController(withIdentifier: ItemDetailConstants.viewIdentifier) as? ItemDetailView)!
		_ = vc.view
		return vc
	}()
	
	// MARK: - Computed VIPER Variables
	lazy var presenter: ItemDetailWireframeToPresenterInterface = self.modulePresenter
	lazy var view: ItemDetailNavigationInterface = self.moduleView
	
	// MARK: - Instance Variables
	var loadingHandler: (() -> Void)?
	
	// MARK: - Initialization
	init(id: String) {
		modulePresenter = ItemDetailPresenter(with: id)
		let i = moduleInteractor
		let p = modulePresenter
		let v = moduleView
		
		i.presenter = p
		
		p.interactor = i
		p.view = v
		p.wireframe = self
		
		v.presenter = p
	}
	
	class func storyboard() -> UIStoryboard {
		return UIStoryboard(name: ItemDetailConstants.storyboardIdentifier,
							bundle: Bundle(for: ItemDetailWireframe.self))
	}
	
	// MARK: - Operational
	class func loadScene(id: String, completion: @escaping (ItemDetailWireframe) -> Void) {
		let wf = ItemDetailWireframe(id: id)
		wf.loadingHandler = { [weak wf] in
			guard let wf = wf else { return }
			completion(wf)
		}
		wf.presenter.loadItem()
	}
	
	deinit {
		LOG("\(#function) \(String(describing: self))")
	}
}

// MARK: - Module Interface
extension ItemDetailWireframe: ItemDetail {
	var delegate: ItemDetailDelegate? {
		get {
			return presenter.delegate
		}
		set {
			presenter.set(delegate: newValue)
		}
	}
}

// MARK: - Presenter to Wireframe Interface
extension ItemDetailWireframe: ItemDetailPresenterToWireframeInterface {
	func didLoadScene() {
		loadingHandler?()
	}
}

// MARK: - Communication Interfaces
// Interface Abstraction for working with the VIPER Module
protocol ItemDetail: class {
	var delegate: ItemDetailDelegate? { get set }
}

// VIPER Module Constants
struct ItemDetailConstants {
	static let storyboardIdentifier = "ItemDetail"
	static let viewIdentifier = "ItemDetailView"
}

// VIPER Interface for manipulating the navigation of the view
protocol ItemDetailNavigationInterface: class {
	
}

// VIPER Interface for communication from Wireframe -> Presenter
protocol ItemDetailWireframeToPresenterInterface: class {
	var delegate: ItemDetailDelegate? { get }
	func set(delegate newDelegate: ItemDetailDelegate?)
	func loadItem()
}
