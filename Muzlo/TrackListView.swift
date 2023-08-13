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

	@ObservedObject var player = Player()
	@ObservedObject var queue = PlayQueue()

	@State var text: String = ""

	public var body: some View {
		RoundedBackground {
			List {
				Section {
					textField()
						.padding(.horizontal, 8)
						.listRowInsets(.none)

					Button(action: {}) {
						HStack(spacing: 0) {
							Spacer()
								.frame(width: 9)

							Image(systemName: "shuffle")
								.resizable()
								.aspectRatio(contentMode: .fit)
								.frame(width: 26)

							Spacer()
								.frame(width: 21)

							Text("Перемешать все")
								.fontWeight(.medium)
						}
						.padding(2)
					}
					.foregroundColor(.blue)
					.buttonStyle(.plain)
					.frame(height: 44)
					.padding(.horizontal, 8)

					ForEach(queue.tracks, id: \.self) { track in
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
	}

	@ViewBuilder func textField() -> some View {
		ZStack {
			RoundedRectangle(cornerRadius: 8)
				.stroke(Color(hex: "555555"), lineWidth: 1)
				.background(
					RoundedRectangle(cornerRadius: 8)
						.fill(Color(hex: "424242"))
				)

			TextField("Поиск треков", text: $text)
				.padding(.horizontal, 8)
		}
		.frame(height: 44)
	}

	@ViewBuilder func cell(for track: Track) -> some View {
		HStack(spacing: 12) {
			Image(uiImage: track.image)
				.resizable()
				.cornerRadius(8)
				.frame(width: 44, height: 44)

			VStack(alignment: .leading, spacing: 2) {
				Text(track.title)
					.foregroundColor(.white)
					.fontWeight(.medium)

				Text(track.artist)
					.foregroundColor(.gray)
			}

			Spacer()

			Text(track.duration)
				.foregroundColor(.gray)
		}
	}
}

final class PlayQueue: ObservableObject {

	@Published var tracks: [Track] = []

	init() {
		Task {
			let urls = FileProvider.shared.urls
			let builder = TrackBuilder()
			var _tracks = [Track]()
			for url in urls {
				let track = try! await builder.track(from: url)
				_tracks.append(track)
			}

			await MainActor.run { [_tracks] in
				self.tracks = _tracks
			}
		}
	}
}

final class TrackBuilder {

	var templatePicture = UIImage(named: "ic_album")!

	func track(from url: URL) async throws -> Track {
		let meta = try ID3Decoder().decode(from: url)
		let asset = AVAsset(url: url)
		let duration = try await asset.load(.duration)
		return Track(
			title: meta.title,
			artist: meta.artist,
			album: meta.album,
			image: meta.image ?? templatePicture,
			duration: String(format: "%02d:%02d", duration.minutes, duration.seconds % 60)
		)
	}
}

extension CMTime {

	var minutes: Int {
		seconds / 60
	}

	var seconds: Int {
		Int(CMTimeGetSeconds(self))
	}
}

extension Color {

	init(hex: String) {
		let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
		var int: UInt64 = 0
		Scanner(string: hex).scanHexInt64(&int)
		let a, r, g, b: UInt64
		switch hex.count {
		case 3: // RGB (12-bit)
			(a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
		case 6: // RGB (24-bit)
			(a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
		case 8: // ARGB (32-bit)
			(a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
		default:
			(a, r, g, b) = (1, 1, 1, 0)
		}

		self.init(
			.sRGB,
			red: Double(r) / 255,
			green: Double(g) / 255,
			blue:  Double(b) / 255,
			opacity: Double(a) / 255
		)
	}
}
