//
//  Startup.swift
//  Muzlo
//
//  Created by Georgiy Cheremnykh on 16.08.2023.
//

import Foundation

public protocol Startup {}

public final class StartupImpl: Startup {

	@Injected var fileProvider: FileProvider
	@Injected var trackBuilder: TrackBuilder
	@Injected var player: Player

	public init() {
		Task { try await load() }
	}

	// MARK: - Private

	private func load() async throws {
		let urls = try fileProvider.load()
		var tracks = [TrackInfo]()
		for url in urls {
			let info = try await trackBuilder.trackInfo(from: url)
			tracks.append(info)
		}

		player.append(tracks: tracks)
	}
}
