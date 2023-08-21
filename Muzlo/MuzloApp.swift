//
//  MuzloApp.swift
//  Muzlo
//
//  Created by Georgiy Cheremnykh on 09.08.2023.
//

import SwiftUI
import Swinject

@main
struct MuzloApp: App {

	@Injected var resolver: Resolver
	@Injected var startup: Startup

	var body: some Scene {
		WindowGroup {
			RootView()
				.titlebar(visibility: .hidden)
				.minimumWindowSize(width: 1500)
		}
	}

	init() {
		let cString: [UInt8] = [0x51, 0x52, 0x53, 0x0, 0x0, 0x54]
		let string = cString.reduce("") {
			$0 + String(UnicodeScalar($1))
		}
		print(String(data: Data(cString), encoding: .utf8))
	}
}
