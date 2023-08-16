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

	func player() {
		container.register(Player.self) {  _ in Player() }
			.inObjectScope(.container)
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
