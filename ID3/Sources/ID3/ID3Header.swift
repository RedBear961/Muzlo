//
//  ID3Header.swift
//  
//
//  Created by Georgiy Cheremnykh on 21.08.2023.
//

import Foundation

private let kSizeLength = 4
private let kFlagsLength = 2
private let kVersionLength = 5

// 4 bytes        | 4 bytes        | 2 bytes
// ID (4 char)    | size 		   | flags
// [$xx xx xx xx] | [$xx xx xx xx] | [$xx xx]
public struct ID3FrameHeader {

	struct Flag: OptionSet {

		let rawValue: UInt16
	}

	public let id: ID3Tag
	let size: Int
	let flags: Flag

	init(from data: Data, for version: ID3Version) throws {
		var iterator = data.componentIterator()

		// Идентификатор блока
		self.id = try iterator.next(
			arrayOf: UInt8.self,
			count: version.frameIDLength
		)

		guard id != .null else {
			self.size = 0
			self.flags = []
			return
		}

		// Размер блока
		let size = iterator
			.next(UInt32.self)
			.bigEndian & version.sizeMask

		// Флаги
		let flags: Flag = iterator.next(UInt16.self)

		self.size = Int(size)
		self.flags = flags
	}
}

// Header size - 10 bytes
// 3 bytes | 2 bytes  | 1 byte      | 4 bytes
// ID      | version  | flags       | size
// ["ID3"] | [$03 00] | [%abc00000] | [4 * %0xxxxxxx]
public struct ID3Header {

	struct Flag: OptionSet {

		let rawValue: UInt8
	}

	public let version: ID3Version
	let flags: Flag
	let size: Int

	init(from data: Data) throws {
		var iterator = data.componentIterator()

		// Версия
		let version: ID3Version = try iterator.next(
			arrayOf: UInt8.self,
			count: kVersionLength
		)

		// Флаги
		let flags: Flag = iterator.next(UInt8.self)

		// Размер
		let size = iterator
			.next(UInt32.self)
			.bigEndian
			.synchsafe

		self.version = version
		self.flags = flags
		self.size = Int(size)
	}
}
