//
//  Time+toString.swift
//  Muzlo
//
//  Created by Georgiy Cheremnykh on 17.08.2023.
//

import Foundation

extension TimeInterval {

	public var hours: Int {
		Int((self/3600).truncatingRemainder(dividingBy: 3600))
	}

	public var minutes: Int {
		Int((self/60).truncatingRemainder(dividingBy: 60))
	}

	public var seconds: Int {
		Int(truncatingRemainder(dividingBy: 60))
	}

	public func toString() -> String {
		"\(minutes):\(format: "%02d", seconds)"
	}
}
