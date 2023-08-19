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

		if let artist = artist(from: meta.artist) {
			track.artist = artist
			artist.add(track: track)

			if let album = album(for: artist, from: meta.album) {
				album.add(track: track)
				track.album = album
			}
		}

		try context.save()

		return track
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

	private func artist(from name: String) -> Artist? {
		guard !name.isEmpty else { return nil }

		if let artist: Artist = try? context.first(where: "name = %@", name) {
			return artist
		}

		let artist = Artist(context: context)
		artist.name = name
		return artist
	}

	private func album(for artist: Artist, from name: String) -> Album? {
		guard !name.isEmpty else { return nil }

		if let album = artist.albums.first(where: { $0.name == name }) {
			return album
		}

		let album = Album(context: context)
		album.name = name
		artist.add(album: album)
		return album
	}
}
