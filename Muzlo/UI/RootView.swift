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

	public var body: some View {
		ZStack {
			theme.current.darkBackground
				.ignoresSafeArea()

			HStack {
				Sidebar()

				VStack(spacing: 24) {
					PlayerView()
						.environmentObject(playback.currentPlayer)

					TrackListView()
				}
			}
			.padding([.bottom, .trailing], .p24)
		}
	}
}
