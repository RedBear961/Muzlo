//
//  PlayerView.swift
//  Muzlo
//
//  Created by Georgiy Cheremnykh on 13.08.2023.
//

import SwiftUI
import Swinject

private let kAlbumSize = 52.0
private let kVolumeThumbSize = 15.0
private let kProgressThumbSize = 10.0
private let kSliderHeight = 3.0

public struct PlayerView: View {

	@InjectedObject private var theme: Appearance
	@EnvironmentObject private var player: Player

	@State private var isDragging = false
	@State private var isProgressThumbVisisble = false
	@State private var progress: CGFloat = 0

	public var body: some View {
		RoundedBackground {
			HStack(spacing: 0) {
				Spacer()

				controls

				Spacer()

				track
					.onHover { isHover in
						withAnimation {
							self.isProgressThumbVisisble = isHover
						}
					}

				Spacer()

				volume

				Spacer()

				options

				Spacer()
					.frame(width: 32)
			}
		}
		.frame(height: 70)
	}

	// MARK: - Private

	private var controls: some View {
		HStack(spacing: 24) {
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
				.height(26)
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
		HStack(spacing: 12) {
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
		VStack(spacing: 6) {
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

				Text(player.state.time) // Оставшеейся время
					.font(.system(size: 16))
					.foregroundColor(theme.secondary)
					.animation(nil)
			}
			.frame(height: 40)

			progressSlider // Слайдер прогресса
		}
	}

	private var progressSlider: some View {
		GeometryReader { geometry in
			let theme = theme.current
			let width = geometry.size.width
			let currentProgress = isDragging ? progress : player.state.progress
			let offset = (width - (kProgressThumbSize)) * currentProgress

			let gesture = DragGesture(minimumDistance: 0)
				.onChanged { value in
					isDragging = true
					progress = value.location.x / width
				}
				.onEnded { value in
					isDragging = false
					progress = value.location.x / width
					player.seek(to: progress)
				}

			ZStack(alignment: .leading) {
				PlayerSlider() // Фон слайдера прогресса
					.foregroundColor(theme.placeholder)
					.frame(height: kSliderHeight)
				PlayerSlider() // Слайдер прогресса
					.foregroundColor(theme.primary)
					.frame(height: kSliderHeight)
					.frame(width: width * currentProgress)

				Circle() // Ползунок слайдера
					.foregroundColor(theme.primary)
					.frame(size: kProgressThumbSize)
					.offset(x: offset)
					.opacity(isProgressThumbVisisble ? 1 : 0)
					.gesture(gesture)
			}
			.simultaneousGesture(gesture)
		}
		.frame(height: kProgressThumbSize)
	}

	private var volume: some View {
		HStack {
			PlainButton(image: .speakerOff) // Выключатель звука
				.bind(to: { player.set(volume: 0) })

			GeometryReader { geometry in
				let width = geometry.size.width
				let theme = theme.current

				let gesture = DragGesture(minimumDistance: 0)
					.onChanged { player.set(volume: $0.location.x / width) }

				ZStack(alignment: .leading) {
					PlayerSlider() // Фон слайдера громкости
						.foregroundColor(theme.placeholder)
						.frame(height: kSliderHeight)

					PlayerSlider() // Слайдер громкости
						.foregroundColor(theme.primary)
						.frame(width: width * player.volume)
						.frame(height: kSliderHeight)

					Circle() // Ползунок слайдера
						.foregroundColor(theme.primary)
						.frame(size: kVolumeThumbSize)
						.offset(x: (width - kVolumeThumbSize) * player.volume)
						.gesture(gesture)
				}
				.simultaneousGesture(gesture)
			}
			.frame(width: 90, height: kVolumeThumbSize)

			PlainButton(image: .speakerOn) // Включатель звука
				.bind(to: { player.set(volume: 1) })
		}
	}

	private var options: some View {
		HStack(spacing: 24) {
			PlainButton(image: .lyrics)

			PlainButton(image: .list)
		}
	}
}

// Обертка для всех сладйеров плеера
fileprivate struct PlayerSlider: View {

	var body: some View {
		RoundedRectangle(cornerRadius: 1.5)
	}
}
