//
//  TrackBuilder.swift
//  Muzlo
//
//  Created by Georgiy Cheremnykh on 16.08.2023.
//

import SwiftUI
import ID3
import AVFoundation

public protocol TrackBuilder {

	func trackInfo(from url: URL) async throws -> TrackInfo
}

public final class TrackBuilderImpl: TrackBuilder {

//	var templatePicture = UIImage(named: "ic_album")!

//	func track(from url: URL) async throws -> Track {
//		let meta = try ID3Decoder().decode(from: url)
//		let asset = AVAsset(url: url)
//		let duration = try await asset.load(.duration)
//		return Track(
//			title: meta.title,
//			artist: meta.artist,
//			album: meta.album,
//			image: meta.image ?? templatePicture,
//			duration: String(format: "%02d:%02d", duration.minutes, duration.seconds % 60)
//		)
//	}

	public func trackInfo(from url: URL) async throws -> TrackInfo {
		let meta = try ID3Decoder().decode(from: url)
		let asset = AVAsset(url: url)
		let duration = try await asset.load(.duration)
		let formatted = String(format: "%d:%02d", duration.minutes, duration.seconds % 60)
		let image = meta.image != nil ? Image(uiImage: meta.image!) : .album
		return TrackInfo(
			title: meta.title,
			artist: meta.artist,
			duration: formatted,
			album: image,
			url: url
		)
	}
}
