//
//  ProductDetail+CoreDataClass.swift
//  ProductListing
//
//  Created by Gökhan KOCA on 27.03.2021.
//
//

import Foundation
import CoreData

@objc(ProductDetail)
public class ProductDetail: Product {
	
	@NSManaged public var desc: String?
	
	enum CodingKeys: String, CodingKey {
		case id = "product_id"
		case name
		case price
		case desc = "description"
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
		self.desc = try container.decodeIfPresent(String.self, forKey: .desc)
		self.image = try container.decodeIfPresent(String.self, forKey: .image)
	}
	
	@nonobjc public class func fetchRequest(with id: String) -> NSFetchRequest<ProductDetail> {
		let fetchRequest = NSFetchRequest<ProductDetail>(entityName: "ProductDetail")
		fetchRequest.predicate =  NSPredicate(format: "id = %@", id)
		return fetchRequest
	}
}
