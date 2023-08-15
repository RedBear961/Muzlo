//
//  Player.swift
//  Muzlo
//
//  Created by Georgiy Cheremnykh on 12.08.2023.
//

import SwiftUI
import AVKit
import ID3

public final class Player: ObservableObject {

	public struct TrackInfo {

		public let title: String
		public let artist: String
		public let duration: String
		public let album: Image

		public static var empty: TrackInfo {
//			TrackInfo(
//				title: "",
//				artist: "",
//				duration: "",
//				album: .asset(.album)
//			)
			TrackInfo(
				title: "Музыка нас связала",
				artist: "Мираж",
				duration: "2:42",
				album: .album
			)
		}
	}

	@Published var isPlaying: Bool = false
	@Published var canBack: Bool = false
	@Published var canForward: Bool = true
	@Published var canPlay: Bool = true
	@Published var volume: CGFloat = 0.5
	@Published var progress: CGFloat = 0.6

	@Published var trackInfo: TrackInfo?

	private var currentPlayer: AVAudioPlayer?
	private var task: Task<Void, Error>?

	init() {
		let url = FileProvider.shared.urls.first!
		self.currentPlayer = try! AVAudioPlayer(contentsOf: url)
		currentPlayer?.volume = Float(volume)
	}

	func play() {
		guard let player = currentPlayer else { return }

		if !isPlaying {
			player.play()
			task = Timer.timer(for: .milliseconds(500), handler: { [self] in
				guard let player = currentPlayer else { return }
				Task { @MainActor in
					withAnimation {
						progress = player.currentTime / player.duration
					}
				}
			})
		} else {
			task?.cancel()
			player.pause()
		}

		isPlaying = !isPlaying
	}

	func setVolume(_ volume: CGFloat) {
		Task { @MainActor in
			let volume = min(max(0, volume), 1)
			self.currentPlayer?.volume = Float(volume)
			self.volume = volume
		}
	}
}

extension Player {

	func back() {

	}

	func forward() {

	}
}

extension Timer {

	static func timer(for duration: Duration, handler: @escaping () -> Void) -> Task<Void, Error> {
		Task<Void, Error> {
			while !Task.isCancelled {
				try await Task.sleep(for: duration)
				handler()
			}
		}
	}
}
