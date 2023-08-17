//
//  RootView.swift
//  Muzlo
//
//  Created by Georgiy Cheremnykh on 13.08.2023.
//

import SwiftUI

public struct RootView: View {

	@InjectedObject var theme: Appearance
	@InjectedObject var playback: Playback
	@Injected var dropHandler: DropDelegate

	public var body: some View {
		ZStack {
			theme.current.darkBackground
				.ignoresSafeArea()

			HStack {
				Sidebar() // Боковая панель

				VStack(spacing: 24) {
					PlayerView() // Плеер
						.environmentObject(playback.currentPlayer)

					TrackListView()
				}
			}
			.padding([.bottom, .trailing], .p24)
		}
		.onDrop(of: [.mp3], isTargeted: nil) { providers in
			playback.process(providers: providers)
		}
	}
}
