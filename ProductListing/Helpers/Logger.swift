//
//  Logger.swift
//  ProductListing
//
//  Created by Gökhan KOCA on 27.03.2021.
//

import Foundation

class Logger {
	
	static let `default` = Logger()
	
	enum Level: Int {
		case none = 0
		case debug, info, warning, error
	}
	
	var loggingLevel: Level
	
	init(minLevel: Level) {
		self.loggingLevel = minLevel
	}
	
	init() {
		if let levelConfig = Bundle.main.infoForKey("LOG_LEVEL"),
		   let levelRaw = Int(levelConfig),
		   let level = Level(rawValue: levelRaw) {
			self.loggingLevel = level
		} else {
			self.loggingLevel = .none
		}
	}
	
	func log(_ message: @autoclosure () -> String, level: Level) {
		if level.rawValue >= loggingLevel.rawValue {
			switch level {
			case .none:
				break
			case .debug:
				print("➡️ \(message())")
			case .info:
				print("ℹ️ \(message())")
			case .warning:
				print("⚠️ \(message())")
			case .error:
				print("⛔️ \(message())")
			}
		}
	}
}

func LOG(level: Logger.Level = .debug, _ message: String) {
	Logger.default.log(message, level: level)
}
