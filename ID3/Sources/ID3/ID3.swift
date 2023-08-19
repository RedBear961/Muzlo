import Foundation

#if os(iOS)
import UIKit
public typealias ID3Image = UIImage
#else
import AppKit
public typealias ID3Image = NSImage
#endif

enum Constants {

	static let headerSize = 10
	static let tagBytesOffset = 6
	static let versionBytesOffset = 3
	static let versionSize = 5
	static let blockSizeLength = 4
	static let encodingOffset = 1
}

public struct ID3Meta {

	public let version: ID3Version
	public let tags: [ID3Tag: Any]

	public var title: String {
		string(for: .title)
	}

	public var artist: String {
		string(for: .artist)
	}

	public var album: String {
		string(for: .album)
	}

	public var image: ID3Image? {
		guard let binary = tags[.attachedPicture] as? Data else {
			return nil
		}
		return ID3Image(data: binary)
	}

	// MARK: - Private

	private func string(for tag: ID3Tag) -> String {
		(tags[tag] as? String) ?? ""
	}
}
