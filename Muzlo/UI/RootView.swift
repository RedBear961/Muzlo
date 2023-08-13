//
//  RootView.swift
//  Muzlo
//
//  Created by Georgiy Cheremnykh on 13.08.2023.
//

import SwiftUI

public struct RootView: View {

	@InjectedObject var theme: Appearance

	public var body: some View {
		ZStack {
			theme.current.darkBackground
				.ignoresSafeArea()

			HStack {
				Sidebar()

				VStack {
					Rectangle()
						.frame(height: 60)
						.cornerRadius(.r12)
						.foregroundColor(theme.current.lightBackground)
						.overlay(
							RoundedRectangle(radius: .r12)
								.stroke(theme.current.textFieldBorder, lineWidth: 0.5)
						)


					Spacer()
						.frame(height: 24)

					PlayerView()
				}
			}
			.padding([.bottom, .trailing], .p24)
		}
	}
}
