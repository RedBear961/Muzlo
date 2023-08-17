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

	@State var text: String = ""

	public var body: some View {
		RoundedBackground {
			NavigationStack {
//				List {
//					Section {
//						textField()
//							.padding(.horizontal, 8)
//							.listRowInsets(.none)
//
//						Button(action: {}) {
//							HStack(spacing: 0) {
//								Spacer()
//									.frame(width: 9)
//
//								Image(systemName: "shuffle")
//									.resizable()
//									.aspectRatio(contentMode: .fit)
//									.frame(width: 26)
//
//								Spacer()
//									.frame(width: 21)
//
//								Text("Перемешать все")
//									.fontWeight(.medium)
//							}
//							.padding(2)
//						}
//						.foregroundColor(.blue)
//						.buttonStyle(.plain)
//						.frame(height: 44)
//						.padding(.horizontal, 8)
//
//						ForEach(queue.tracks, id: \.self) { track in
//							cell(for: track)
//								.padding(2)
//						}
//						.padding(.horizontal, 8)
//					}
//					.listRowSeparator(.hidden)
//					.listRowBackground(Color.clear)
//				}
//				.padding(.vertical, 8)
//				.listStyle(.plain)
//				.scrollContentBackground(.hidden)
			}
			.cornerRadius(12)
		}
	}

//	@ViewBuilder func textField() -> some View {
//		ZStack {
//			RoundedRectangle(cornerRadius: 8)
//				.stroke(Color(hex: "555555"), lineWidth: 1)
//				.background(
//					RoundedRectangle(cornerRadius: 8)
//						.fill(Color(hex: "424242"))
//				)
//
//			TextField("Поиск треков", text: $text)
//				.padding(.horizontal, 8)
//		}
//		.frame(height: 44)
//	}
//
//	@ViewBuilder func cell(for track: Track) -> some View {
//		HStack(spacing: 12) {
//			Image(uiImage: track.image)
//				.resizable()
//				.cornerRadius(8)
//				.frame(width: 44, height: 44)
//
//			VStack(alignment: .leading, spacing: 2) {
//				Text(track.title)
//					.foregroundColor(.white)
//					.fontWeight(.medium)
//
//				Text(track.artist)
//					.foregroundColor(.gray)
//			}
//
//			Spacer()
//
//			Text(track.duration)
//				.foregroundColor(.gray)
//		}
//	}
}

extension CMTime {

	var minutes: Int {
		seconds / 60
	}

	var seconds: Int {
		Int(CMTimeGetSeconds(self))
	}
}
