//
//  File.swift
//  
//
//  Created by Georgiy Cheremnykh on 12.08.2023.
//

import Foundation
import Logger

public enum ID3DecodingError: Error {

	case unknown
	case badFile
	case unsupportedVersion
}

// Маркер пустого фрейма.
private let kEmptyFrame: [UInt8] = [0x0, 0x0, 0x0, 0x0]

public final class ID3Decoder {

	public init() {}

	public func decode(from url: URL) throws -> ID3Meta {
		// Блок тэгов.
		let data = try frame(from: url)

		// Версия ID3.
		let version = try version(from: data)
		let tagDecoder = ID3TagDecoder(version: version)

		var tags = [ID3Tag: Any]()
		var position = Constants.headerSize
		while position < data.count {
			// Размер тэга.
			let frameSize = blockSize(
				for: data as NSData,
				position: position,
				version: version
			)

			// Имя тэга.
			let frame = data.subdata(from: position, count: frameSize)
			let identifier = [UInt8](frame.subdata(in: 0..<version.identifierSize))
			
			position += frame.count

			// Если пустой фрейм, то либо метадата закончилась,
			// либо записана с ошибкой.
			if identifier == kEmptyFrame {
				break
			}

			// Значение тэга.
			if let tag = ID3Tag(scalar: identifier),
			   let value = tagDecoder.decode(tag, from: frame) {
				tags[tag] = value
			}

			Logger.shared.assert(
				ID3Tag(scalar: identifier) != nil,
				message: identifier.reduce("") { $0 + String(UnicodeScalar($1)) }
			)
		}

		return ID3Meta(version: version, tags: tags)
	}

	// MARK: - Private

	// Header size - 10 bytes
	// 3 bytes | 2 bytes  | 1 byte      | 4 bytes
	// ID      | version  | flags       | size
	// ["ID3"] | [$03 00] | [%abc00000] | [4 * %0xxxxxxx]
	private func frame(from url: URL) throws -> Data {
		guard let stream = InputStream(url: url) else {
			throw ID3DecodingError.unknown
		}

		stream.open()

		// Размер блока тэгов.
		let header = try stream.read(count: Constants.headerSize)
		let tagSize = Data(header).withUnsafeBytes { buffer in
			let size = buffer.baseAddress!
				.advanced(by: Constants.tagBytesOffset)
				.assumingMemoryBound(to: UInt32.self)
				.pointee
				.bigEndian
			return SynchsafeDecoder().decode(size)
		}

		let frame = try stream.read(count: Int(tagSize))
		return Data(header + frame)
	}

	private func version(from data: Data) throws -> ID3Version {
		guard data.count > Constants.versionBytesOffset else {
			throw ID3DecodingError.badFile
		}

		let header = [UInt8](data.subdata(in: 0..<Constants.versionSize))
		let versionRaw = [UInt8](data)[Constants.versionBytesOffset]
		guard let version = ID3Version(rawValue: versionRaw),
			  header.elementsEqual(version.header) else {
			throw ID3DecodingError.unsupportedVersion
		}

		return version
	}

	// 4 bytes        | 4 bytes        | 2 bytes
	// ID (4 char)    | size 		   | flags
	// [$xx xx xx xx] | [$xx xx xx xx] | [$xx xx]
	private func blockSize(
		for data: NSData,
		position: Int,
		version: ID3Version
	) -> Int {
		let position = position + version.sizeOffset
		let range = NSRange(
			location: position,
			length: Constants.blockSizeLength
		)
		var size: UInt32 = 0
		data.getBytes(&size, range: range)
		size = size.bigEndian & version.sizeMask
		return Int(size + UInt32(Constants.headerSize))
	}
}
