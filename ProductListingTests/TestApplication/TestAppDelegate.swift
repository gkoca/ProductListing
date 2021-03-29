//
//  TestAppDelegate.swift
//  ProductListingTests
//
//  Created by Gökhan KOCA on 27.03.2021.
//

import UIKit
import CoreData
import ProductListing

@objc(TestAppDelegate)
final class TestAppDelegate: UIResponder, UIApplicationDelegate, CoreDataCapable {

	static let shared = UIApplication.shared.delegate as? TestAppDelegate
	
	func application(_ application: UIApplication,
					 didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		for sceneSession in application.openSessions {
			application.perform(Selector(("_removeSessionFromSessionSet:")), with: sceneSession)
		}
		return true
	}

	// MARK: UISceneSession Lifecycle
	func application(_ application: UIApplication,
					 configurationForConnecting connectingSceneSession: UISceneSession,
					 options: UIScene.ConnectionOptions) -> UISceneConfiguration {
		let sceneConfiguration = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
		sceneConfiguration.delegateClass = TestSceneDelegate.self
		return sceneConfiguration
	}
	
	lazy var persistentContainer: NSPersistentContainer = {
		let container = NSPersistentContainer(name: "ProductListing")
		container.loadPersistentStores(completionHandler: { (storeDescription, error) in
			if let error = error as NSError? {
				fatalError("Unresolved error \(error), \(error.userInfo)")
			}
		})
		return container
	}()

	func saveContext () {
		let context = persistentContainer.viewContext
		if context.hasChanges {
			do {
				try context.save()
			} catch {
				let nserror = error as NSError
				fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
			}
		}
	}
	
	public func clearAllCoreData() {
		let entities = self.persistentContainer.managedObjectModel.entities
		entities.compactMap({ $0.name }).forEach(clearDeepObjectEntity)
	}

	private func clearDeepObjectEntity(_ entity: String) {
		let context = self.persistentContainer.viewContext

		let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
		let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)

		do {
			try context.execute(deleteRequest)
			try context.save()
		} catch {
			print ("There was an error")
		}
	}
}

