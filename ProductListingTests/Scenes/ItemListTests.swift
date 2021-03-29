//
//  ItemListTests.swift
//  ProductListingTests
//
//  Created by Gökhan KOCA on 28.03.2021.
//

import XCTest
@testable import ProductListing

class ItemListTests: XCTestCase {

	var sutWireFrame: ItemListWireframe?
	var sutView: ItemListView?
	var sutPresenter: ItemListPresenter?
	var sutInteractor: ItemListInteractor?
	
	override func setUp() {
		super.setUp()
		TestAppDelegate.shared?.clearAllCoreData()
		let semaphore = DispatchSemaphore(value: 0)
		ItemListWireframe.loadScene { (wireFrame) in
			self.sutWireFrame = wireFrame
			self.sutView = wireFrame.moduleView
			self.sutPresenter = wireFrame.modulePresenter
			self.sutInteractor = wireFrame.moduleInteractor
			UIApplication.shared.windows.first?.rootViewController = wireFrame.moduleNavigationController
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
		XCTAssertEqual(sutPresenter?.products.count, 6)
		XCTAssertEqual(sutPresenter?.products.first?.id, "1")
		XCTAssertEqual(sutPresenter?.products.first?.name, "Apples")
		XCTAssertEqual(sutPresenter?.products.first?.image, "https://s3-eu-west-1.amazonaws.com/developer-application-test/images/1.jpg")
		XCTAssertEqual(sutPresenter?.products.first?.price, 120.0)
		sutPresenter?.loadItems()
		XCTAssertEqual(sutPresenter?.products.count, 6)
		XCTAssertEqual(sutPresenter?.products.first?.id, "1")
		XCTAssertEqual(sutPresenter?.products.first?.name, "Apples")
		XCTAssertEqual(sutPresenter?.products.first?.image, "https://s3-eu-west-1.amazonaws.com/developer-application-test/images/1.jpg")
		XCTAssertEqual(sutPresenter?.products.first?.price, 120.0)
	}
	
	func testcollectionView() {
		XCTAssertNotNil(sutView)
		XCTAssertNotNil(sutView?.collectionView)
		XCTAssertEqual(sutView?.title, "Products")
		XCTAssertNotNil(sutView?.collectionView.delegate)
		XCTAssertNotNil(sutView?.collectionView.dataSource)
		XCTAssertEqual(sutView?.collectionView.numberOfSections, 1)
		XCTAssertEqual(sutView?.collectionView.numberOfItems(inSection: 0), 6)
		let layout = sutView?.collectionView?.collectionViewLayout as? UICollectionViewFlowLayout
		XCTAssertEqual(layout?.scrollDirection, .vertical)
		XCTAssertEqual(layout?.sectionInset, UIEdgeInsets(top: 8, left: 8, bottom: 0, right: 8))
		XCTAssertEqual(layout?.minimumInteritemSpacing, 0)
		XCTAssertEqual(layout?.minimumLineSpacing, 16)
		let side = (UIScreen.main.bounds.width - 32) / 2
		XCTAssertEqual(layout?.itemSize, CGSize(width: side, height: side))
	}
	
	func testCollectionViewContent() {
		guard let collectionView = sutView?.collectionView else {
			XCTAssert(false)
			return
		}
		
		let cell1 = sutView?.collectionView(
			collectionView, cellForItemAt: IndexPath(item: 0, section: 0)) as? ProductCollectionViewCell
		
		let cell2 = sutView?.collectionView(
			collectionView, cellForItemAt: IndexPath(item: 1, section: 0)) as? ProductCollectionViewCell
		
		XCTAssertEqual(cell1?.nameLabel.text, "Apples")
		XCTAssertEqual(cell2?.nameLabel.text, "Oranges")
		
		XCTAssertEqual(cell1?.priceLabel.text, "120.00")
		XCTAssertEqual(cell2?.priceLabel.text, "167.00")
		
		XCTAssertEqual(cell1?.imageView.image?.pngData()?.count, 7236874)
		XCTAssertEqual(cell2?.imageView.image?.pngData()?.count, 2974175)
	}
	
	func testGoToDetail() {
		guard let collectionView = sutView?.collectionView else {
			XCTAssert(false)
			return
		}

		sutView?.collectionView(collectionView, didSelectItemAt: IndexPath(item: 0, section: 0))
		XCTAssertNotNil(sutWireFrame?.currentOpenedDetailWireFrame)
		XCTAssertNotNil(sutWireFrame?.currentOpenedDetailWireFrame?.moduleView)
		XCTAssertNotNil(sutWireFrame?.currentOpenedDetailWireFrame?.modulePresenter)
		XCTAssertNotNil(sutWireFrame?.currentOpenedDetailWireFrame?.moduleInteractor)
	}
	
	func testGoBack() {
		guard let collectionView = sutView?.collectionView else {
			XCTAssert(false)
			return
		}
		sutView?.collectionView(collectionView, didSelectItemAt: IndexPath(item: 0, section: 0))
		RunLoop.main.run(until: Date(timeIntervalSinceNow: 1))
		sutWireFrame?.currentOpenedDetailWireFrame?.moduleView.navigationController?.popViewController(animated: false)
		RunLoop.main.run(until: Date(timeIntervalSinceNow: 1))
		XCTAssertNil(sutWireFrame?.currentOpenedDetailWireFrame)
		XCTAssertNil(sutWireFrame?.currentOpenedDetailWireFrame?.moduleView)
		XCTAssertNil(sutWireFrame?.currentOpenedDetailWireFrame?.modulePresenter)
		XCTAssertNil(sutWireFrame?.currentOpenedDetailWireFrame?.moduleInteractor)
	}
}
