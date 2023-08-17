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

	func track(from url: URL) async throws -> Track

	func trackInfo(from url: URL) async throws -> TrackInfo
}

public final class TrackBuilderImpl: TrackBuilder {

	@Injected private var decoder: ID3Decoder
	@Injected private var fileProvider: FileProvider
	@ManagedObjectContext private var context

	public func track(from url: URL) async throws -> Track {
		let id = UUID()
		let url = try fileProvider.copyFile(from: url, with: id)
		let meta = try decoder.decode(from: url)
		let duration = try await duration(from: url)
		let _ = image(from: meta)

		let track = Track(context: context)
		track.name = meta.title
		track.id = id
		track.duration = duration
		track.url = url

		return track
	}

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

	// MARK: - Private

	private func duration(from url: URL) async throws -> String {
		let asset = AVAsset(url: url)
		let time =  try! await asset.load(.duration)
		return "\(time.minutes):\(format: "%02d", time.seconds % 60)"
	}

	private func image(from meta: ID3Meta) -> UIImage {
		return UIImage(named: "ic_album")!
	}
}
