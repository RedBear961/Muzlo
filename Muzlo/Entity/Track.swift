//
//  ID3Decoder.swift
//  Muzlo
//
//  Created by Georgiy Cheremnykh on 11.08.2023.
//

import Foundation
import SwiftUI

//struct Track: Hashable {
//
//	let title: String
//	let artist: String
//	let album: String
//	let image: UIImage
//	let duration: String
//}

public struct TrackInfo {

	public let title: String
	public let artist: String
	public let duration: String
	public let album: Image
	public let url: URL

	public static var empty: TrackInfo {
		TrackInfo(
			title: "",
			artist: "",
			duration: "",
			album: .album,
			url: URL(string: "http://yourmom.zip")!
		)
	}
}
