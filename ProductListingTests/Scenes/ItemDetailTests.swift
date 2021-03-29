//
//  ItemDetailTests.swift
//  ProductListingTests
//
//  Created by Gökhan KOCA on 28.03.2021.
//

import XCTest
@testable import ProductListing

class ItemDetailTests: XCTestCase {
	
	var sutWireFrame: ItemDetailWireframe?
	var sutView: ItemDetailView?
	var sutPresenter: ItemDetailPresenter?
	var sutInteractor: ItemDetailInteractor?
	
	override func setUp() {
		super.setUp()
		TestAppDelegate.shared?.clearAllCoreData()
		let semaphore = DispatchSemaphore(value: 0)
		ItemDetailWireframe.loadScene(id: "1") { (wireFrame) in
			self.sutWireFrame = wireFrame
			self.sutView = wireFrame.moduleView
			self.sutPresenter = wireFrame.modulePresenter
			self.sutInteractor = wireFrame.moduleInteractor
			let navigationController = UINavigationController(rootViewController: wireFrame.moduleView)
			UIApplication.shared.windows.first?.rootViewController = navigationController
			semaphore.signal()
		}
		semaphore.wait()
	}
	
	override func tearDown() {
		super.tearDown()
		TestAppDelegate.shared?.clearAllCoreData()
	}
	
	func testLoadScene() {
		XCTAssertNotNil(sutWireFrame)
		XCTAssertNotNil(sutView)
		XCTAssertNotNil(sutPresenter)
		XCTAssertNotNil(sutInteractor)
	}
	
	func testPresenter() {
		XCTAssertEqual(sutPresenter?.itemId, "1")
		XCTAssertEqual(sutPresenter?.item.name, "Apples")
		XCTAssertEqual(sutPresenter?.item.image, "https://s3-eu-west-1.amazonaws.com/developer-application-test/images/1.jpg")
		XCTAssertEqual(sutPresenter?.item.price, 120)
		XCTAssertEqual(sutPresenter?.item.desc, "An apple a day keeps the doctor away.")
	}
	
	func testView() {
		XCTAssertEqual(sutView?.title, "Apples")
		XCTAssertEqual(sutView?.nameLabel.text, "Apples")
		XCTAssertEqual(sutView?.priceLabel.text, "120.00")
		XCTAssertEqual(sutView?.descriptionLabel.text, "An apple a day keeps the doctor away.")
		XCTAssertEqual(sutView?.imageView.image?.pngData()?.count, 7236874)
	}
}
