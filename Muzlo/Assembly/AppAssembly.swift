//
//  AppAssembly.swift
//  Muzlo
//
//  Created by Georgiy Cheremnykh on 13.08.2023.
//

import Foundation
import Swinject
import SwiftUI
import ID3

final class AppAssembly: AutoAssembly {

	func appearance() {
		container.register(Appearance.self) { _ in Appearance() }
			.inObjectScope(.container)
	}

	func fileProvider() {
		container.register(FileProvider.self) { _ in FileProviderImpl() }
	}

	func fileManager() {
		container.register(FileManager.self) { _ in FileManager.default }
	}

	func startup() {
		container.register(Startup.self) { _ in StartupImpl() }
	}

	func trackBuilder() {
		container.register(TrackBuilder.self) { _ in TrackBuilderImpl() }
	}

	func id3Decoder() {
		container.register(ID3Decoder.self) { _ in ID3Decoder() }
	}

	func coreDataStorage() {
		container.register(CoreDataStorage.self) { _ in CoreDataStorageImpl() }
			.inObjectScope(.container)
	}
}
