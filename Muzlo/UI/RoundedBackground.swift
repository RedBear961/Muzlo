//
//  RoundedBackground.swift
//  Muzlo
//
//  Created by Georgiy Cheremnykh on 13.08.2023.
//

import SwiftUI

public struct RoundedBackground<Content: View>: View {

	@InjectedObject var theme: Appearance
	@ViewBuilder public let content: () -> Content

	public var body: some View {
		ZStack {
			theme.current.lightBackground
				.ignoresSafeArea()
				.cornerRadius(12)
				.overlay(
					RoundedRectangle(cornerRadius: 12)
						.stroke(theme.current.lightBorder, lineWidth: 0.5)
				)

			content()
		}
	}
}
