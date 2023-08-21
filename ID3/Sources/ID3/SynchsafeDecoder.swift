//
//  SynchsafeDecoder.swift
//  
//
//  Created by Georgiy Cheremnykh on 12.08.2023.
//

import Foundation

/// https://stackoverflow.com/a/5223228
struct SynchsafeDecoder {

	func decode(_ integer: UInt32) -> UInt32 {
		var decoded: UInt32 = 0
		var mask: UInt32 = 0x7F000000

		while mask != 0 {
			decoded = decoded >> 1
			decoded = decoded | integer & mask
			mask >>= 8
		}

		return decoded
	}
}

extension UInt32 {

	var synchsafe: UInt32 {
		SynchsafeDecoder().decode(self)
	}
}
