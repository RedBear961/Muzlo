//
//  AppAssembly.swift
//  Muzlo
//
//  Created by Georgiy Cheremnykh on 13.08.2023.
//

import Swinject

final class AppAssembly: AutoAssembly {

	func appearance() {
		container.register(Appearance.self) { _ in Appearance() }
	}

	func player() {
		container.register(Player.self) {  _ in Player() }
	}
}
