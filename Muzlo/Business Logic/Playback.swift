//
//  Playback.swift
//  Muzlo
//
//  Created by Georgiy Cheremnykh on 17.08.2023.
//

import Foundation
import UniformTypeIdentifiers

public final class Playback: ObservableObject {

	@Published public var currentPlayer: Player

	public init(player: Player) {
		self.currentPlayer = player
	}

	public func process(providers: [ItemProvider]) -> Bool {
		let providers = providers.filter { $0.hasItemConforming(to: .mp3) }
		Task {
			var items = [URL]()
			for provider in providers {
				let url = try await provider.loadFileRepresentation(for: .mp3)
				items.append(url)
			}
		}
		return !providers.isEmpty
	}
}
