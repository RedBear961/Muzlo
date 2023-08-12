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
