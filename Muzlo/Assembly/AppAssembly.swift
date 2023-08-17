//
//  AppAssembly.swift
//  Muzlo
//
//  Created by Georgiy Cheremnykh on 13.08.2023.
//

import Foundation
import Swinject

final class AppAssembly: AutoAssembly {

	func appearance() {
		container.register(Appearance.self) { _ in Appearance() }
			.inObjectScope(.container)
	}

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

	func fileProvider() {
		container.register(FileProvider.self) { _ in FileProviderImpl() }
	}

	func fileManager() {
		container.register(FileManager.self) { _ in FileManager.default }
			.inObjectScope(.container)
	}

	func startup() {
		container.register(Startup.self) { _ in StartupImpl() }
	}

	func trackBuilder() {
		container.register(TrackBuilder.self) { _ in TrackBuilderImpl() }
	}
}
