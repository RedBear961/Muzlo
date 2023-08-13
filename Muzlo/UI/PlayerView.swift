//
//  PlayerView.swift
//  Muzlo
//
//  Created by Georgiy Cheremnykh on 13.08.2023.
//

import SwiftUI
import Swinject

public struct PlayerView: View {

	@InjectedObject var theme: Appearance
	@InjectedObject var player: Player

	@State var volume: CGFloat = 0.5
	@State private var ratio: CGFloat = 0

	public var body: some View {
		RoundedBackground {
			HStack(spacing: 24) {
				Spacer()
//					.frame(width: 60)

				mediaControls

				Spacer()
//					.frame(width: 60)

				HStack(spacing: 12) {
					Image("ic_album")
						.resizable()
						.frame(width: 52, height: 52)
						.cornerRadius(.r8)

					VStack(spacing: 6) {
						trackInfo

						durationSlider
					}
				}
				.frame(width: 500)

				Spacer()

				HStack {
					Button(action: {}) {
						Image(systemName: "speaker.fill")
							.foregroundColor(.white)
					}

					volumeSlider

					Button(action: {}) {
						Image(systemName: "speaker.wave.3.fill")
							.foregroundColor(.white)
					}
				}

				Spacer()

				controlButton(
					action: {},
					image: "textformat",
					height: 18
				)

				controlButton(
					action: {},
					image: "list.bullet",
					height: 18
				)

				Spacer()
					.frame(width: 16)
			}
		}
		.frame(height: 70)
	}

	// MARK: - Private

	@ViewBuilder private var mediaControls: some View {
		controlButton(
			action: {},
			image: "shuffle",
			height: 18
		)

		controlButton(
			action: player.back,
			image: "backward.fill",
			height: 18
		)

		controlButton(
			action: player.togglePlay,
			image: player.isPlaying ? "pause.fill" : "play.fill",
			height: 26
		)

		controlButton(
			action: player.next,
			image: "forward.fill",
			height: 18
		)

		controlButton(
			action: {},
			image: "repeat",
			height: 18
		)
	}

	private var trackInfo: some View {
		HStack {
			VStack(alignment: .leading) {
				Text("Музыка нас связала")
					.font(.system(size: 17, weight: .semibold))
					.foregroundColor(.white)

				Text("Мираж")
					.font(.system(size: 17))
					.foregroundColor(.gray)
			}

			Spacer()

			Text("2:42")
				.font(.system(size: 16))
				.foregroundColor(.gray)
		}
	}

	private var durationSlider: some View {
		ZStack(alignment: .leading) {
			RoundedRectangle(cornerRadius: 1.5)
				.frame(height: 3)
				.foregroundColor(Color(hex: "454545"))

			RoundedRectangle(cornerRadius: 1.5)
				.frame(width: 300, height: 3)
		}
	}

	private var volumeSlider: some View {
		GeometryReader { geometry in
			ZStack(alignment: .leading) {
				RoundedRectangle(cornerRadius: 1.5)
					.foregroundColor(Color(hex: "454545"))
					.frame(height: 3)

				RoundedRectangle(cornerRadius: 1.5)
					.foregroundColor(.white)
					.frame(width: geometry.size.width * volume, height: 3)


				Circle()
					.foregroundColor(.white)
					.frame(width: 15, height: 15)
					.offset(x: (geometry.size.width - 15) * volume)
					.gesture(
						DragGesture(minimumDistance: 0)
							.onChanged { value in
								self.volume = min(max(0, value.location.x / geometry.size.width), 1)
							}
					)
			}
			.cornerRadius(12)
		}
		.frame(width: 90, height: 15)
	}

	private func controlButton(
		action: @escaping () -> Void,
		image name: String,
		height: CGFloat
	) -> some View {
		Button(action: action) {
			Image(systemName: name)
				.resizable()
				.aspectRatio(contentMode: .fit)
				.foregroundColor(.white)
				.frame(height: height)
		}
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
	}
}
