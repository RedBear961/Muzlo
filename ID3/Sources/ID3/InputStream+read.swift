//
//  File.swift
//  
//
//  Created by Georgiy Cheremnykh on 12.08.2023.
//

import Foundation

extension InputStream {

	func read(count: Int) throws -> [UInt8] {
		var buffer = [UInt8](repeating: 0, count: count)
		let result = read(&buffer, maxLength: count)
		if result != count {
			throw ID3DecodingError.unknown
		}
		return buffer
	}
}
