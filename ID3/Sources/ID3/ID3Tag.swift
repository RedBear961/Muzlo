//
//  ID3Tag.swift
//  Muzlo
//
//  Created by Georgiy Cheremnykh on 10.08.2023.
//

import Foundation

public enum ID3Tag: String, Equatable {

	case title = "TIT2"
	case artist = "TPE1"
	case composer = "TCOM"
	case conductor = "TPE3"
	case copyright = "TCOP"
	case lyricist = "TEXT"
	case mixArtist = "TPE4"
	case publisher = "TPUB"
	case subtitle = "TIT3"
	case album = "TALB"
	case attachedPicture = "APIC"
	case recordingYear = "TYER"
	case genre = "TCON"
	case trackPosition = "TRCK"
	case discPosition = "TPOS"
	case albumArtist = "TPE2"
	case unsyncronisedLyrics = "USLT"
	case comment = "COMM"
	case originalFilename = "TOFN"
	case null = ""
}

// Маркер пустого фрейма.
private let kEmptyFrame: [UInt8] = [0x0, 0x0, 0x0, 0x0]

extension ID3Tag: ExpressibleByArray {

	public init?(_ array: [UInt8]) {
		if array == kEmptyFrame {
			self = .null
			return
		}

		let identifier = array.reduce("") {
			$0 + String(UnicodeScalar($1))
		}
		self.init(rawValue: identifier)
	}
}
