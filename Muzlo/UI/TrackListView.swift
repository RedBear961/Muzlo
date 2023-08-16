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
//		Task {
//			let urls = FileProvider.shared.urls
//			let builder = TrackBuilder()
//			var _tracks = [Track]()
//			for url in urls {
//				let track = try! await builder.track(from: url)
//				_tracks.append(track)
//			}
//
//			await MainActor.run { [_tracks] in
//				self.tracks = _tracks
//			}
//		}
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

	func trackInfo(from url: URL) async throws -> TrackInfo {
		let meta = try ID3Decoder().decode(from: url)
		let asset = AVAsset(url: url)
		let duration = try await asset.load(.duration)
		let formatted = String(format: "%d:%02d", duration.minutes, duration.seconds % 60)
		let image = meta.image != nil ? Image(uiImage: meta.image!) : .album
		return TrackInfo(
			title: meta.title,
			artist: meta.artist,
			duration: formatted,
			album: image,
			url: url
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
