//
//  AppDelegate.swift
//  ProductListing
//
//  Created by Gökhan KOCA on 27.03.2021.
//

import UIKit
import CoreData

public protocol CoreDataCapable: class {
	func saveContext()
	var persistentContainer: NSPersistentContainer { get }
}

class AppDelegate: UIResponder, UIApplicationDelegate, CoreDataCapable {

	static let shared = UIApplication.shared.delegate as? AppDelegate

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		return true
	}

	// MARK: UISceneSession Lifecycle

	func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
		return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
	}

	// MARK: - Core Data stack
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

}

