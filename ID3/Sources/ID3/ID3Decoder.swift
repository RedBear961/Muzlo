//
//  ID3Decoder.swift
//  
//
//  Created by Georgiy Cheremnykh on 12.08.2023.
//

import Foundation
import Logger

protocol ID3Frame {

	var header: ID3FrameHeader { get }
}

// [Header] | [$xx] | [Text]
struct ID3TextFrame: ID3Frame {

	let header: ID3FrameHeader
	let encoding: String.Encoding
	let text: String

	init?(header: ID3FrameHeader, from data: Data) {
		var iterator = data.componentIterator()

		guard let encoding = iterator.textEncoding(),
			  let text = iterator.text(encoding: encoding) else {
			return nil
		}

		self.header = header
		self.encoding = encoding
		self.text = text
	}
}

struct ID3DataFrame: ID3Frame {

	let header: ID3FrameHeader
	let data: Data
}

public enum ID3DecodingError: Error {

	case unknown
	case badFile
	case unsupportedVersion
}

public final class ID3Decoder {

	public init() {}

	public func decode(from url: URL) throws -> ID3Meta {
		let (header, data) = try frame(from: url)
		let tagDecoder = ID3TagDecoder(version: header.version)

		var tags = [ID3Tag: ID3Frame]()
		var position = 0
		while position < data.count {
			let frameHeader = try ID3FrameHeader(
				from: data,
				for: header.version
			)

			guard frameHeader.id != .null else { break }

			let value = tagDecoder.decode(
				frame: frameHeader,
				from: data[10...]
			)

			if let value {
				tags[frameHeader.id] = value
			}

			position += frameHeader.size
		}

		return ID3Meta(header: header, tags: tags)
	}

	// MARK: - Private

	// Header size - 10 bytes
	// 3 bytes | 2 bytes  | 1 byte      | 4 bytes
	// ID      | version  | flags       | size
	// ["ID3"] | [$03 00] | [%abc00000] | [4 * %0xxxxxxx]
	private func frame(from url: URL) throws -> (ID3Header, Data) {
		guard let stream = InputStream(url: url) else {
			throw ID3DecodingError.unknown
		}

		stream.open()

		// Размер блока тэгов.
		let bytes = try stream.read(count: Constants.headerSize)
		let header = try ID3Header(from: Data(bytes))
		let frame = try stream.read(count: header.size)
		return (header, Data(frame))
	}
}
