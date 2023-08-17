//
//  PlayerView.swift
//  Muzlo
//
//  Created by Georgiy Cheremnykh on 13.08.2023.
//

import SwiftUI
import Swinject

private let kControlsSpacing = 24.0
private let kPlayButtonHeight = 26.0
private let kAlbumSize = 52.0
private let kTrackSpacing = 12.0
private let kTrackInfoSpacing = 6.0
private let kVolumeSliderWidth = 90.0
private let kThumbSize = 15.0
private let kSliderHeight = 3.0
private let kTrailingOffset = 32.0
private let kPlayerHeight = 70.0

public struct PlayerView: View {

	@InjectedObject var theme: Appearance
	@EnvironmentObject var player: Player

	@State var isDragging = false
	@State var progress: CGFloat = 0

	public var body: some View {
		RoundedBackground {
			HStack(spacing: 0) {

				Spacer()

				controls

				Spacer()

				track

				Spacer()

				volume

				Spacer()

				options

				Spacer()
					.frame(width: kTrailingOffset)
			}
		}
		.frame(height: kPlayerHeight)
	}

	// MARK: - Private

	private var controls: some View {
		HStack(spacing: kControlsSpacing) {
			// Перемешать
			PlainButton(image: .shuffle)
				.disabled(!player.state.canPlay)

			// Предыдущий трек
			PlainButton(image: .backward)
				.bind(to: player.back)
				.disabled(!player.state.canBack)

			// Плей/пауза
			PlainButton(image: player.state.isPlaying ? .pause : .play)
				.bind(to: { player.state.isPlaying ? player.pause() : player.play() })
				.height(kPlayButtonHeight)
				.disabled(!player.state.canPlay)

			// Следующий трек
			PlainButton(image: .forward)
				.bind(to: player.forward)
				.disabled(!player.state.canForward)

			// Повторять
			PlainButton(image: .repeat)
				.disabled(!player.state.canPlay)
		}
	}

	private var track: some View {
		HStack(spacing: kTrackSpacing) {
			let info = player.trackInfo ?? .empty
			info.album
				.resizable()
				.frame(size: kAlbumSize)
				.cornerRadius(.r8)

			trackInfo
		}
		.frame(width: 500)
	}

	private var trackInfo: some View {
		VStack(spacing: kTrackInfoSpacing) {
			let info = player.trackInfo ?? .empty
			let theme = theme.current
			HStack {
				VStack(alignment: .leading) {
					Text(info.title) // Название аудио
						.fontWeight(.semibold)
						.foregroundColor(theme.primary)

					Text(info.artist) // Исполнитель
						.foregroundColor(theme.secondary)
				}
				.font(.system(size: 17))

				Spacer()

				Text(info.duration) // Длительность
					.font(.system(size: 16))
					.foregroundColor(theme.secondary)
			}
			.frame(height: 40)

			GeometryReader { geometry in
				let width = geometry.size.width
				let progress = isDragging ? progress : player.state.progress
				let offset = (width - (kSliderHeight + 3)) * progress
				ZStack(alignment: .leading) {
					slider // Фон слайдера прогресса
						.foregroundColor(theme.placeholder)
						.frame(height: kSliderHeight)
					slider // Слайдер прогресса
						.foregroundColor(theme.primary)
						.frame(height: kSliderHeight)
						.frame(width: width * progress)

					Circle()
						.foregroundColor(theme.primary)
						.frame(size: kSliderHeight + 3)
						.offset(x: offset)
						.gesture(
							DragGesture()
								.onChanged({ value in
									isDragging = true
									self.progress = value.location.x / width
								})
								.onEnded({ value in
									isDragging = false
									self.progress = value.location.x / width
									player.seek(to: progress)
								})
						)
				}
			}
			.frame(height: kSliderHeight + 3)
		}
	}

	private var volume: some View {
		HStack {
			PlainButton(image: .speakerOff) // Выключатель звука
				.bind(to: { player.set(volume: 0) })

			GeometryReader { geometry in
				let width = geometry.size.width
				let theme = theme.current
				ZStack(alignment: .leading) {
					slider // Фон слайдера громкости
						.foregroundColor(theme.placeholder)
						.frame(height: kSliderHeight)

					slider // Слайдер громкости
						.foregroundColor(theme.primary)
						.frame(width: width * player.volume)
						.frame(height: kSliderHeight)

					Circle() // Ползунок слайдера
						.foregroundColor(theme.primary)
						.frame(size: kThumbSize)
						.offset(x: (width - kThumbSize) * player.volume)
						.gesture(
							DragGesture(minimumDistance: 0)
								.onChanged {
									player.set(volume: $0.location.x / width)
								}
						)
				}
			}
			.frame(width: kVolumeSliderWidth, height: kThumbSize)

			PlainButton(image: .speakerOn) // Включатель звука
				.bind(to: { player.set(volume: 1) })
		}
	}

	private var options: some View {
		HStack(spacing: kControlsSpacing) {
			PlainButton(image: .lyrics)

			PlainButton(image: .list)
		}
	}

	private var slider: some View {
		RoundedRectangle(cornerRadius: kSliderHeight / 2)
	}
}

struct PlayerView_Previews: PreviewProvider {

	static var container = Container.forPreview { container in
		container.register(Player.self) { _ in Player() }
		container.register(Appearance.self) { _ in Appearance() }
	}

	static var previews: some View {
		PlayerView()
			.frame(width: 1200)
			.environmentObject(container.resolve(Player.self)!)
	}
}
