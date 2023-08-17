//
//  QueuePlayer.swift
//  Muzlo
//
//  Created by Georgiy Cheremnykh on 17.08.2023.
//

import AVKit
import SwiftUI
import Logger

public final class QueuePlayer: Player {

	private var currentPlayer: AVAudioPlayer?
	private var progressTask: Task<Void, Error>?

	private var history: Stack<TrackInfo>
	private var queue: Stack<TrackInfo>

	public override init() {
		self.history = Stack()
		self.queue = Stack()
		super.init()
		self.progressTask = Task { try await handleProgress() }
	}

	// MARK: - Player Interface

	/// Запускает воспроизведение текущего трека.
	/// Если нет текущего трека, то возьмет трек из очереди проигрывания.
	public override func play() {
		guard !state.isPlaying else {
			Logger.shared.log(
				level: .warning,
				"Attempt to call `Player.play()` when playback is running!"
			)
			return
		}

		if let player = currentPlayer {
			player.play()
			state.isPlaying = true
			return
		}

		guard state.canForward else {
			Logger.shared.log(
				level: .error,
				"Attempt to call `Player.play()` with an empty play queue!"
			)
			return
		}

		forward()
		state.isPlaying = true
	}

	/// Останавливает воспроизведение.
	public override func pause() {
		guard let player = currentPlayer, state.isPlaying else {
			Logger.shared.log(
				level: .warning,
				"Attempt to call `Player.pause()` when playback is stopped"
			)
			return
		}

		player.pause()
		state.isPlaying = false
	}


	/// Переключает на предыдущую композицию.
	public override func back() {
		guard let currentInfo = trackInfo else {
			Logger.shared.log(
				level: .error,
				"Attempt to call `Player.back()` with an empty history!"
			)
			return
		}

		queue.push(currentInfo)
		state.canForward = true

		let info = try! history.pop()
		playTrack(info)
		state.canBack = !history.isEmpty
	}

	/// Переключает на следующую композицию.
	public override func forward() {
		guard state.canForward else {
			Logger.shared.log(
				level: .warning,
				"Attempt to call `Player.back()` with an empty history!"
			)
			return
		}

		if let currentInfo = trackInfo {
			history.push(currentInfo)
			state.canBack = true
		}

		let info = try! queue.pop()
		playTrack(info)
		state.canForward = !queue.isEmpty
	}

	/// Устанавливает громкость плеера в интервале от `0` до `1`.
	public override func set(volume: CGFloat) {
		Task { @MainActor in
			let volume = min(max(0, volume), 1)
			self.currentPlayer?.volume = Float(volume)
			self.volume = volume
		}
	}

	public override func seek(to progress: CGFloat) {
		guard let player = currentPlayer else {
			Logger.shared.log(
				level: .warning,
				"Attempt to call `Player.set(to:)` when playback is not prepared!"
			)
			return
		}

		state.progress = progress
		player.currentTime = player.duration * progress
	}

	// MARK: - Queue Player

	/// Добавляет треки в конец очереди.
	public func append(tracks: [TrackInfo]) {
		queue.append(tracks)
		Task { @MainActor in
			state.canForward = !queue.isEmpty
			state.canPlay = currentPlayer != nil || state.canForward
		}
	}

	// MARK: - Private

	private func playTrack(_ track: TrackInfo) {
		let player = try! AVAudioPlayer(contentsOf: track.url)
		player.delegate = self
		player.prepareToPlay()
		player.volume = Float(volume)
		player.play()

		self.currentPlayer = player
		self.trackInfo = track
	}

	private func handleProgress() async throws {
		while !Task.isCancelled {
			try await Task.sleep(for: .microseconds(500))
			guard let player = currentPlayer else { continue }
			await MainActor.run {
				withAnimation {
					state.progress = player.currentTime / player.duration
				}
			}
		}
	}
}

// MARK: - AVAudioPlayerDelegate

extension QueuePlayer: AVAudioPlayerDelegate {

	public func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
		if state.canForward {
			forward()
		}
	}
}
