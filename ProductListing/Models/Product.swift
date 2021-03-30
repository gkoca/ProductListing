//
//  Product+CoreDataClass.swift
//  ProductListing
//
//  Created by Gökhan KOCA on 27.03.2021.
//
//

import Foundation
import CoreData

@objc(Product)
public class Product: NSManagedObject, Decodable, Identifiable {
	
	@NSManaged public var id: String?
	@NSManaged public var name: String?
	@NSManaged public var price: Double
	@NSManaged public var image: String?
	@NSManaged public var detail: ProductDetail?
	
	enum CodingKeys: String, CodingKey {
		case id = "product_id"
		case name
		case price
		case image
	}
	
	required convenience public init(from decoder: Decoder) throws {
		guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
			throw DecoderConfigurationError.missingManagedObjectContext
		}
		self.init(context: context)
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.id = try container.decodeIfPresent(String.self, forKey: .id)
		self.name = try container.decodeIfPresent(String.self, forKey: .name)
		self.price = try container.decodeIfPresent(Double.self, forKey: .price) ?? 0
		self.image = try container.decodeIfPresent(String.self, forKey: .image)
	}
	
	@nonobjc public class func fetchRequest() -> NSFetchRequest<Product> {
		return NSFetchRequest<Product>(entityName: "Product")
	}
	
	@nonobjc public class func fetchRequest(with id: String) -> NSFetchRequest<Product> {
		let fetchRequest = NSFetchRequest<Product>(entityName: "Product")
		fetchRequest.predicate =  NSPredicate(format: "id = %@", id)
		return fetchRequest
	}
}
