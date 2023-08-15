//
//  PlainButton.swift
//  Muzlo
//
//  Created by Georgiy Cheremnykh on 15.08.2023.
//

import SwiftUI

public struct PlainButton: View {

	private let image: Image

	@Environment(\.foregroundColor)
	private var foregroundColor: Color

	@Environment(\.height)
	private var height: CGFloat

	@Environment(\.action)
	private var action: () -> Void

	@Environment(\.isEnabled)
	private var isEnabled: Bool

	public var body: some View {
		Button(action: action) {
			image
				.resizable()
				.renderingMode(.template)
				.aspectRatio(contentMode: .fit)
				.foregroundColor(isEnabled ? foregroundColor : foregroundColor.opacity(0.2))
				.frame(height: height)
		}
	}

	public func foregroundColor(_ color: Color) -> some View {
		environment(\.foregroundColor, color)
	}

	public init(image: Image) {
		self.image = image
	}
}
