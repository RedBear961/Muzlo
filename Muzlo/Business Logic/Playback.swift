//
//  Playback.swift
//  Muzlo
//
//  Created by Georgiy Cheremnykh on 17.08.2023.
//

import Foundation

public final class Playback: ObservableObject {

	@Published public var currentPlayer: Player

	public init(player: Player) {
		self.currentPlayer = player
	}

	public func append(tracks: [Track]) {
		
	}
}
