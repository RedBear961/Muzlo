//
//  File.swift
//  
//
//  Created by Georgiy Cheremnykh on 12.08.2023.
//

import Foundation

public extension Data {

	func subdata(from location: Int, count: Int) -> Data {
		return subdata(in: location..<location + count)
	}

	func subdata(from location: Int) -> Data {
		return subdata(in: location..<count)
	}

	func subdata(to byte: UInt8) -> Data? {
		var index: Int?
		try? withUnsafeBytes<UInt8> { pointer in
			let pointer = pointer.assumingMemoryBound(to: UInt8.self)
			for i in 0..<count {
				guard pointer[i] == byte else { continue }

				index = i
				return
			}
		}

		guard let index else { return nil }
		return subdata(in: 0..<index)
	}
}
