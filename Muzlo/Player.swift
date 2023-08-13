//
//  Player.swift
//  Muzlo
//
//  Created by Georgiy Cheremnykh on 12.08.2023.
//

import SwiftUI
import AVKit
import ID3

final class Player: ObservableObject {

	var players: [AudioPlayer] = []
	var index: Int = 0
	var urls: [URL] = []
	var currentPlayer: AudioPlayer?

	@Published var sliderTime: Double = 0
	@Published var duration: Double = 0
	@Published var time: TimeInterval = 0
	@Published var isPlaying: Bool = false

	init() {
		_play()
	}

	func togglePlay() {
		isPlaying ? pause() : play()
	}

	func play() {
		isPlaying = true
		currentPlayer?.play()
	}

	func pause() {
		isPlaying = false
		currentPlayer?.pause()
	}

	func _play() {
		self.urls = FileProvider.shared.urls
		let player = AudioPlayer(contentsOf: urls.first!)

		let _ = try! ID3Decoder().decode(from: urls.first!)

		currentPlayer = player
		duration = player.duration
		players.append(player)
	}
}

final class AudioPlayer: NSObject {

	private let player: AVAudioPlayer
	private var observers: [NSKeyValueObservation] = []

	init(contentsOf url: URL) {
		self.player = try! AVAudioPlayer(contentsOf: url)
		super.init()
	}

	var duration: TimeInterval {
		player.duration
	}

	var currentTime: TimeInterval {
		player.currentTime
	}

	func play() {
		player.play()
	}

	func pause() {
		player.pause()
	}
}
