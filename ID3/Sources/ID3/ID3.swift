import Foundation

#if os(iOS)
import UIKit
typealias ID3Image = UIImage
#else
import AppKit
typealias ID3Image = NSImage
#endif

enum Constants {

	static let headerSize = 10
	static let tagBytesOffset = 6
	static let versionBytesOffset = 3
	static let versionSize = 5
	static let blockSizeLength = 4
	static let encodingOffset = 1
}

enum FrameEncoding: UInt8 {

	case isoLatin = 0
	case utf16 = 1

	var asStringEncoding: String.Encoding {
		switch self {
		case .isoLatin:
			return .isoLatin1
		case .utf16:
			return .utf16
		}
	}
}

struct ID3TagDecoder {

	private let version: ID3Version

	init(version: ID3Version) {
		self.version = version
	}

	func decode(tag: ID3Tag, from data: Data) -> Any? {
		var value: Any?
		switch tag {
		case .title, .artist, .album, .publisher:
			value = string(from: data)
		case .attachedPicture:
			value = image(from: data)
		default:
			preconditionFailure()
		}

		#if DEBUG
		assert(value != nil, tag.rawValue)
		#endif

		return value
	}

	func string(from data: Data) -> String? {
		let encoding = FrameEncoding(rawValue: data[Constants.headerSize]) ?? .isoLatin
		let subdata = data.subdata(in: Constants.headerSize + 1..<data.count)
		let value = String(data: subdata, encoding: encoding.asStringEncoding)
		return value
	}

	func image(from data: Data) -> ID3Image? {
//		let encoding = data[Constants.headerSize]
		return ID3Image(named: "")
	}
}

extension Data {

	func subdata(from location: Int, count: Int) -> Data {
		return subdata(in: location..<location + count)
	}
}



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
