//
//  DropHandler.swift
//  Muzlo
//
//  Created by Georgiy Cheremnykh on 17.08.2023.
//

import Foundation
import UniformTypeIdentifiers

public protocol DropHandler {

	func handle(providers: [ItemProvider]) -> Bool
}

public final class DropHandlerImpl: DropHandler {

	@Injected private var trackBuilder: TrackBuilder
	@Injected private var playback: Playback

	public func handle(providers: [ItemProvider]) -> Bool {
		let providers = providers.filter {
			$0.hasItemConforming(to: .mp3)
		}

		Task {
			var tracks = [Track]()
			for provider in providers {
				let url = try await provider.loadFileRepresentation(for: .mp3)
				let track = try await trackBuilder.track(from: url)
				tracks.append(track)
			}
			playback.append(tracks: tracks)
		}
		
		return !providers.isEmpty
	}
}
