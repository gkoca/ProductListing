//
//  ItemListWireframe.swift
//  ProductListing
//
//  Created by Gökhan KOCA on 27.03.2021.
//

import UIKit

class ItemListWireframe {
	// MARK: - VIPER Stack
	lazy var moduleInteractor = ItemListInteractor()
	
	lazy var moduleNavigationController: UINavigationController = {
		let sb = ItemListWireframe.storyboard()
		let nc = (sb.instantiateViewController(withIdentifier: ItemListConstants.navigationControllerIdentifier) as? UINavigationController)!
		return nc
	}()
	
	lazy var modulePresenter = ItemListPresenter()
	lazy var moduleView: ItemListView = {
		let vc = self.moduleNavigationController.viewControllers[0] as! ItemListView
		_ = vc.view
		return vc
	}()
	
	// MARK: - Computed VIPER Variables
	lazy var presenter: ItemListWireframeToPresenterInterface = self.modulePresenter
	lazy var view: ItemListNavigationInterface = self.moduleView
	
	// MARK: - Instance Variables
	var loadingHandler: (() -> Void)?
	var currentOpenedDetailWireFrame: ItemDetailWireframe?
	
	// MARK: - Initialization
	init() {
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
		return UIStoryboard(name: ItemListConstants.storyboardIdentifier,
							bundle: Bundle(for: ItemListWireframe.self))
	}
	
	// MARK: - Operational
	class func loadScene(completion: @escaping (ItemListWireframe) -> Void) {
		let wf = ItemListWireframe.init()
		wf.loadingHandler = {
			completion(wf)
		}
		wf.presenter.loadItems()
	}
	
	deinit {
		LOG("\(#function) \(String(describing: self))")
	}
}

// MARK: - Module Interface
extension ItemListWireframe: ItemList {
	var delegate: ItemListDelegate? {
		get {
			return presenter.delegate
		}
		set {
			presenter.set(delegate: newValue)
		}
	}
}

// MARK: - Presenter to Wireframe Interface
extension ItemListWireframe: ItemListPresenterToWireframeInterface {
	func gotoDetail(with id: String) {
		ItemDetailWireframe.loadScene(id: id) { [weak self] (wireFrame) in
			self?.currentOpenedDetailWireFrame = wireFrame
			self?.currentOpenedDetailWireFrame?.delegate = self
			self?.moduleView.show(wireFrame.moduleView, sender: self)
		}
	}
	
	func didLoadScene() {
		loadingHandler?()
	}
}

extension ItemListWireframe: ItemDetailDelegate {
	func moduleShouldDispose() {
		currentOpenedDetailWireFrame = nil
	}
}
// MARK: - Communication Interfaces
// Interface Abstraction for working with the VIPER Module
protocol ItemList: class {
	var delegate: ItemListDelegate? { get set }
}

// VIPER Module Constants
struct ItemListConstants {
	static let navigationControllerIdentifier = "ItemListNavigationController"
	static let storyboardIdentifier = "ItemList"
	static let viewIdentifier = "ItemListView"
}

// VIPER Interface for manipulating the navigation of the view
protocol ItemListNavigationInterface: class {
	
}

// VIPER Interface for communication from Wireframe -> Presenter
protocol ItemListWireframeToPresenterInterface: class {
	var delegate: ItemListDelegate? { get }
	func set(delegate newDelegate: ItemListDelegate?)
	func loadItems()
}
