//
//  PlayerView.swift
//  Muzlo
//
//  Created by Georgiy Cheremnykh on 09.08.2023.
//

import SwiftUI
import ID3
import AVKit

public struct Sidebar: View {

	public var body: some View {
		Text("Моя музыка")
			.frame(width: 300)
	}
}

public struct TrackListView: View {

	@InjectedObject private var mediateka: Mediateka

	public var body: some View {
		RoundedBackground {
			NavigationStack {
				List {
					Section {
						ForEach(mediateka.tracks, id: \.self) { track in
							cell(for: track)
								.padding(2)
						}
						.padding(.horizontal, 8)
					}
					.listRowSeparator(.hidden)
					.listRowBackground(Color.clear)
				}
				.padding(.vertical, 8)
				.listStyle(.plain)
				.scrollContentBackground(.hidden)
			}
			.cornerRadius(12)
		}
	}

	@ViewBuilder func cell(for track: Track) -> some View {
		HStack(spacing: 12) {
			Image.album
				.resizable()
				.cornerRadius(8)
				.frame(width: 44, height: 44)

			VStack(alignment: .leading, spacing: 2) {
				Text(track.name)
					.foregroundColor(.white)
					.fontWeight(.medium)

				Text(track.artist?.name ?? "")
					.foregroundColor(.gray)
			}

			Spacer()

			Text(track.duration)
				.foregroundColor(.gray)
		}
	}
}
