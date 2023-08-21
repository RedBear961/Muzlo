//
//  ID3Version.swift
//  Muzlo
//
//  Created by Georgiy Cheremnykh on 11.08.2023.
//

import Foundation

public enum ID3Version {

	case v2
	case v3
	case v4
}

extension ID3Version: ExpressibleByArray {

	public init?(_ array: [UInt8]) {
		let header = [UInt8]("ID3".utf8)
		switch array {
		case header + [0x02, 0x00]:
			self = .v2
		case header + [0x03, 0x00]:
			self = .v3
		case header + [0x04, 0x00]:
			self = .v4
		default:
			return nil
		}
	}
}

extension ID3Version {

	var frameIDLength: Int {
		switch self {
		case .v2: return 3
		case .v3: return 4
		case .v4: return 4
		}
	}

	var sizeMask: UInt32 {
		switch self {
		case .v2: return 0x00FFFFFF
		case .v3: return 0xFFFFFFFF
		case .v4: return 0xFFFFFFFF
		}
	}
}
