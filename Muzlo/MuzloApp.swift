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

	var body: some Scene {
		WindowGroup {
			RootView()
				.titlebar(visibility: .hidden)
				.minimumWindowSize(width: 1500)
		}
	}
}
