//
//  ID3Version.swift
//  Muzlo
//
//  Created by Georgiy Cheremnykh on 11.08.2023.
//

import Foundation

public enum ID3Version: UInt8 {

	case v2 = 2
	case v3 = 3
	case v4 = 4
}

extension ID3Version {

	var header: [UInt8] {
		let header = [UInt8]("ID3".utf8)
		switch self {
		case .v2: return header + [0x02, 0x00]
		case .v3: return header + [0x03, 0x00]
		case .v4: return header + [0x04, 0x00]
		}
	}

	var sizeOffset: Int {
		switch self {
		case .v2: return 2
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

	var identifierSize: Int {
		switch self {
		case .v2: return 3
		case .v3: return 4
		case .v4: return 4
		}
	}
}
