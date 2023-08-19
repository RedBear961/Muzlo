//
//  PlayerAssembly.swift
//  Muzlo
//
//  Created by Georgiy Cheremnykh on 17.08.2023.
//

import Foundation
import Swinject

final class PlayerAssembly: AutoAssembly {

	func queuePlayer() {
		container.register(QueuePlayer.self) {  _ in QueuePlayer() }
			.inObjectScope(.container)
	}

	func radioPlayer() {
		container.register(RadioPlayer.self) {  _ in RadioPlayer() }
			.inObjectScope(.container)
	}

	func playback() {
		container.register(Playback.self) { (r) in
			Playback(player: r.resolve(QueuePlayer.self)!)
		}.inObjectScope(.container)
	}

	func mediateka() {
		container.register(Mediateka.self) { _ in Mediateka() }
			.inObjectScope(.container)
	}
}
