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
public class ProductDetail: NSManagedObject, Decodable, Identifiable  {
	
	@NSManaged public var id: String?
	@NSManaged public var desc: String?
	@NSManaged public var ofProduct: Product?
	
	enum CodingKeys: String, CodingKey {
		case id = "product_id"
		case desc = "description"
	}
	
	required convenience public init(from decoder: Decoder) throws {
		guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
			throw DecoderConfigurationError.missingManagedObjectContext
		}
		self.init(context: context)
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.id = try container.decodeIfPresent(String.self, forKey: .id)
		self.desc = try container.decodeIfPresent(String.self, forKey: .desc)
	}
	
	@nonobjc public class func fetchRequest(with id: String) -> NSFetchRequest<ProductDetail> {
		let fetchRequest = NSFetchRequest<ProductDetail>(entityName: "ProductDetail")
		fetchRequest.predicate =  NSPredicate(format: "id = %@", id)
		return fetchRequest
	}
}
