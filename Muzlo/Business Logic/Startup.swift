//
//  Startup.swift
//  Muzlo
//
//  Created by Georgiy Cheremnykh on 16.08.2023.
//

import Foundation

public protocol Startup {}

public final class StartupImpl: Startup {

	@Injected var player: QueuePlayer
	@Injected var mediateka: Mediateka

	public init() {
		player.append(tracks: mediateka.tracks)
	}
}
