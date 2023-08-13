//
//  RootView.swift
//  Muzlo
//
//  Created by Georgiy Cheremnykh on 13.08.2023.
//

import SwiftUI

public struct RootView: View {

	public var body: some View {
		ZStack {
			Color(hex: "141414")
				.ignoresSafeArea()

			HStack {
				Sidebar()

				VStack {
					Rectangle()
						.frame(height: 60)
						.cornerRadius(12)
						.foregroundColor(Color(hex: "222222"))
						.overlay(
							RoundedRectangle(cornerRadius: 12)
								.stroke(Color(hex: "555555"), lineWidth: 0.5)
						)


					Spacer()
						.frame(height: 24)

					PlayerView()
				}
			}
			.padding(.bottom, 24)
			.padding(.trailing, 24)
		}
	}
}
