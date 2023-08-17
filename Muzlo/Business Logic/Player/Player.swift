//
//  Player.swift
//  Muzlo
//
//  Created by Georgiy Cheremnykh on 12.08.2023.
//

import SwiftUI

public class Player: NSObject, ObservableObject {

	public enum PlayerFailure: Error {

		case unknown
	}

	public struct State {

		public var isPlaying: Bool

		public var canBack: Bool
		public var canForward: Bool
		public var canPlay: Bool

		public var progress: CGFloat
		public var time: String
	}

	@Published public var state: State
	@Published public var volume: CGFloat = 0.5
	@Published public var trackInfo: TrackInfo?

	public override init() {
		self.state = State(
			isPlaying: false,
			canBack: false,
			canForward: false,
			canPlay: false,
			progress: 0,
			time: ""
		)
		super.init()
	}

	/// Запускает воспроизведение текущего трека.
	/// Если нет текущего трека, то возьмет трек из очереди проигрывания.
	public func play() {
	}

	/// Останавливает воспроизведение.
	public func pause() {
	}


	/// Переключает на предыдущую композицию.
	public func back() {
	}

	/// Переключает на следующую композицию.
	public func forward() {
	}

	/// Устанавливает громкость плеера в интервале от `0` до `1`.
	public func set(volume: CGFloat) {
	}

	/// Перематывает аудио трек на установленный прогресс.
	public func seek(to progress: CGFloat) {
	}
}
