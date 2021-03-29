//
//  CartService.swift
//  ProductListing
//
//  Created by Gökhan KOCA on 27.03.2021.
//

import Foundation

// https://s3-eu-west-1.amazonaws.com/developer-application-test/cart/list
// https://s3-eu-west-1.amazonaws.com/developer-application-test/cart/1/detail

enum CartService: Caller {
	case list
	case detail(id: String)
	
	var baseURL: URL {
		let baseURLString = Bundle.main.infoForKey("BASE_URL") ?? ""
		return URL(forceString: baseURLString)
	}
	
	var path: String {
		switch self {
		case .list:
			return "cart/list"
		case .detail(let id):
			return "cart/\(id)/detail"
		}
	}
	
	var method: HTTPMethod {
		return .get
	}
	
	var parameters: [String : Any] {
		return [:]
	}
	
	var task: HTTPTask {
		return .requestParameters(parameters: parameters, encoding: .urlEncoding)
	}
	
	var mock: Data {
		switch self {
		case .list:
			return getData(with: "mockList") ?? Data()
		case .detail(let id):
			switch id {
			case "1":
				return getData(with: "mockDetail") ?? Data()
			default:
				return Data()
			}
		}
	}
	
	func getData(with fileName: String) -> Data? {
		if let path = Bundle.main.path(forResource: fileName, ofType: "json"),
		   let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe) {
			return data
		}
		return nil
	}
}
