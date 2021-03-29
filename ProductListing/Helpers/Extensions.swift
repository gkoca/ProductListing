//
//  Extensions.swift
//  ProductListing
//
//  Created by Gökhan KOCA on 27.03.2021.
//
import UIKit

extension Bundle {
	func infoForKey(_ key: String) -> String? {
		return (infoDictionary?[key] as? String)?.replacingOccurrences(of: "\\", with: "")
	}
}

extension URL {
	init(forceString string: String) {
		guard let url = URL(string: string) else { fatalError("Could not init URL '\(string)'") }
		self = url
	}
}

extension UIImageView {
	func load(from urlString: String, contentMode: UIView.ContentMode = .scaleAspectFit, placeholder: String? = nil) {
		self.contentMode = contentMode
		if urlString.isEmpty {
			LOG("IMAGE -> Path is empty")
			if let placeholder = placeholder {
				LOG(level: .info, "IMAGE -> Returning placeholder")
				self.image = UIImage(named: placeholder)
				return
			}
			LOG(level: .error, "IMAGE -> Returning nil")
			return
		}
		
		let url = URL(forceString: urlString)
		if let path = url.pathComponents.last, let image = ImageRepository.shared.getImage(with: path) {
			self.image = image
			return
		}
		LOG("IMAGE -> downloading from \(url.absoluteString)")
		Session.shared.session.dataTask(with: url) {(data, response, error) in
			guard
				let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
				let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
				let data = data, error == nil,
				let image = UIImage(data: data)
			else {
				if let placeholder = placeholder {
					DispatchQueue.main.async { [weak self] in
						LOG("IMAGE -> download failed. Returning placeholder")
						self?.image = UIImage(named: placeholder)
					}
				} else {
					LOG(level: .error, "IMAGE -> Returning nil")
				}
				return
			}
			LOG(level: .info, "IMAGE -> download success. size: \(data.count)")
			if let path = url.pathComponents.last {
				ImageRepository.shared.cache(image: image, with: path)
			}
			DispatchQueue.main.async { [weak self] in
				self?.image = image
			}
		}.resume()
	}
}

extension Thread {
  var isRunningXCTest: Bool {
	for key in self.threadDictionary.allKeys {
	  guard let keyAsString = key as? String else {
		continue
	  }
	
	  if keyAsString.split(separator: ".").contains("xctest") {
		return true
	  }
	}
	return false
  }
}
