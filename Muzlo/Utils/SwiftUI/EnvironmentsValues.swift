//
//  EnvironmentsValues.swift
//  Muzlo
//
//  Created by Georgiy Cheremnykh on 15.08.2023.
//

import SwiftUI

private struct HeightKey: EnvironmentKey {

	static var defaultValue: CGFloat = 18
}

private struct ActionKey: EnvironmentKey {

	static var defaultValue = {}
}

private struct ForegroundColorKey: EnvironmentKey {

	static var defaultValue: Color = .white
}

extension EnvironmentValues {

	var height: CGFloat {
		get { self[HeightKey.self] }
		set { self[HeightKey.self] = newValue }
	}

	var action: () -> Void {
		get { self[ActionKey.self] }
		set { self[ActionKey.self] = newValue }
	}

	var foregroundColor: Color {
		get { self[ForegroundColorKey.self] }
		set { self[ForegroundColorKey.self] = newValue }
	}
}

extension View {

	func bind(to action: @escaping () -> Void) -> some View {
		environment(\.action, action)
	}

	func height(_ height: CGFloat) -> some View {
		environment(\.height, height)
	}
}
