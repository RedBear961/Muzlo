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
}

public final class ID3Decoder {

	public func decode(from url: URL) throws -> TrackMeta {
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

		// Блок тэгов.
		let frame = try stream.read(count: Int(tagSize))
		let data = Data(header + frame)

		// Версия ID3.
		let version = try version(from: data)
		let tagDecoder = ID3TagDecoder(version: version)

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

			// Значение тэга.
			if let tag = ID3Tag(scalar: identifier),
			   let value = tagDecoder.decode(tag: tag, from: frame) {
				Logger.shared.log(tag, value)
			}

			#if DEBUG
			assert(ID3Tag(scalar: identifier) != nil, identifier.reduce("") { $0 + String(UnicodeScalar($1)) })
			#endif

			position += frame.count
		}

		return TrackMeta(version: version)
	}

	// MARK: - Private

	private func version(from data: Data) throws -> ID3Version {
		guard data.count > Constants.versionBytesOffset else {
			throw ID3DecodingError.unknown
		}

		let header = [UInt8](data.subdata(in: 0..<Constants.versionSize))
		let versionRaw = [UInt8](data)[Constants.versionBytesOffset]
		guard let version = ID3Version(rawValue: versionRaw),
			  header.elementsEqual(version.header) else {
			throw ID3DecodingError.unknown
		}

		return version
	}

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
