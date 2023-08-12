//
//  ID3Decoder.swift
//  Muzlo
//
//  Created by Georgiy Cheremnykh on 11.08.2023.
//

import Foundation
import SwiftUI

struct Track {

	let baseUrl: URL

	let title: String
	let artist: String
	let album: String

	var preview: NSImage {
		get async {
			await loadImage()
		}
	}

	func loadImage() async -> NSImage {
		return NSImage(named: "")!
	}
}
