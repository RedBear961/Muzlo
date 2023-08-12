//
//  PlayerView.swift
//  Muzlo
//
//  Created by Georgiy Cheremnykh on 09.08.2023.
//

import SwiftUI
import AVKit
import ID3

public struct PlayerView: View {

	@ObservedObject var player = Player()

	public var body: some View {
		NavigationSplitView {
			Text("123")
		} detail: {
			VStack {
				Text("\(Int(player.time / 60)):\(Int(player.time) % 60)")

				HStack {
					Button(action: player.play) {
						Text("Play")
					}

					Button(action: player.pause) {
						Text("Pause")
					}
				}

				Slider(value: $player.sliderTime, in: 0...player.duration)
			}
			.padding()
			.toolbar {
				HStack {
					Button(action: player.togglePlay) {
						Image(systemName: player.isPlaying ? "pause.circle.fill" : "play.circle.fill")
//							.resizable()
					}
				}
			}
		}
	}
}

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

extension TimeInterval {
	var hourMinuteSecondMS: String {
		String(format:"%d:%02d:%02d.%03d", hour, minute, second, millisecond)
	}
	var minuteSecondMS: String {
		String(format:"%d:%02d.%03d", minute, second, millisecond)
	}
	var hour: Int {
		Int((self/3600).truncatingRemainder(dividingBy: 3600))
	}
	var minute: Int {
		Int((self/60).truncatingRemainder(dividingBy: 60))
	}
	var second: Double {
		truncatingRemainder(dividingBy: 60)
	}
	var millisecond: Int {
		Int((self*1000).truncatingRemainder(dividingBy: 1000))
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

final class FileProvider {

	static let shared = FileProvider()

	var urls: [URL] {
		let fileManager = FileManager.default
		let appDirectory = "/Users/\(NSUserName())/Music/Muzlo"
		if !fileManager.fileExists(atPath: appDirectory) {
			try! fileManager.createDirectory(
				atPath: appDirectory,
				withIntermediateDirectories: true
			)
		}
		let contents = try! fileManager.contentsOfDirectory(atPath: appDirectory)
		return contents.compactMap { file in
			guard let fileExtension = file.split(separator: ".").last,
				  fileExtension == "mp3" else {
				return nil
			}

			return URL(filePath: appDirectory).appending(path: file)
		}
	}
}

