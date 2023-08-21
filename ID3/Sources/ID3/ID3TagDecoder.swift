//
//  ID3TagDecoder.swift
//  
//
//  Created by Georgiy Cheremnykh on 12.08.2023.
//

import Foundation
import Logger

private let kNullTerminator: UInt8 = 0x0

enum ImageFormat: String {

	case jpeg = "image/jpg"
	case png = "image/png"
}

extension ImageFormat {

	var header: Data {
		switch self {
		case .jpeg:	return Data([0xFF, 0xD8, 0xFF, 0xE0])
		case .png:	return Data([0x89, 0x50, 0x4E, 0x47])
		}
	}

	init?(data: Data, encoding: String.Encoding) {
		guard let raw = String(data: data, encoding: encoding) else {
			return nil
		}
		self.init(rawValue: raw)
	}
}

struct ID3TagDecoder {

	private let version: ID3Version

	init(version: ID3Version) {
		self.version = version
	}

	func decode(frame: ID3FrameHeader, from data: Data) -> ID3Frame? {
		var segment: ID3Frame?
		switch frame.id {
		case .attachedPicture:
			guard let image = image(from: data) else { break }
			segment = ID3DataFrame(
				header: frame,
				data: image
			)
		case .title, .artist, .album, .recordingYear:
			segment = ID3TextFrame(header: frame, from: data)
		default:
			return nil
		}

		return segment
	}

	// [Header] | [$xx] | [Binary Data]
	private func image(from data: Data) -> Data? {
		let frame = data.subdata(from: Constants.headerSize + 1)

		let marker = data[Constants.headerSize]
		guard let encoding = encoding(from: marker),
			  let mime = frame.subdata(to: kNullTerminator),
			  let format = ImageFormat(data: mime, encoding: encoding),
			  let range = frame.range(of: format.header) else {
			Logger.shared.assert(true, message: "Bad encoding marker - '\(marker)'!")
			return nil
		}

		return frame.subdata(from: range.lowerBound)
	}

	private func encoding(from marker: UInt8) -> String.Encoding? {
		switch marker {
		case 0x0:	return .isoLatin1
		case 0x1:	return .utf16
		case 0x3:	return .utf8
		default:
			return nil
		}
	}
}
