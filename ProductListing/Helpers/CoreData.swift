//
//  CoreData.swift
//  ProductListing
//
//  Created by Gökhan KOCA on 27.03.2021.
//

import Foundation
import CoreData

extension CodingUserInfoKey {
  static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")!
}

enum DecoderConfigurationError: Error {
  case missingManagedObjectContext
}
