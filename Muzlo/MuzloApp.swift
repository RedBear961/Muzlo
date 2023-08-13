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

	@InjectedResolver var resolver

	var body: some Scene {
		WindowGroup {
			RootView()
				.titlebar(visibility: .hidden)
		}
	}
}
