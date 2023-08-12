//
//  MuzloApp.swift
//  Muzlo
//
//  Created by Georgiy Cheremnykh on 09.08.2023.
//

import SwiftUI
import Logger

@main
struct MuzloApp: App {

    var body: some Scene {
        WindowGroup {
            PlayerView()
        }
		.windowToolbarStyle(.unified(showsTitle: false))
		.windowStyle(.titleBar)
    }
}
