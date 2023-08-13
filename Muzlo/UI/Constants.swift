//
//  Constants.swift
//  Muzlo
//
//  Created by Georgiy Cheremnykh on 13.08.2023.
//

import SwiftUI

public enum Constants {

	public enum ButtonHeight {

		public static let main: CGFloat = 42
	}

	public enum AnimationDuration {

		// https://developer.apple.com/documentation/uikit/uiview/1622617-setanimationduration
		/// 0.2f
		public static let `default`: Double = 0.2
	}
}

// MARK: - Constants.Radius

extension Constants {

	/// Константы для cornerRadius
	public enum Radius: CGFloat {

		/// 4.0f
		case r4 = 4

		/// 8.0f
		case r8 = 8

		/// 12.0f
		case r12 = 12

		/// 16.0f
		case r16 = 16

		/// 20.0f
		case r20 = 20

		/// 32.0f
		case r32 = 32
	}
}

extension View {

	public func cornerRadius(_ radius: Constants.Radius, antialiased: Bool = true) -> some View {
		cornerRadius(radius.rawValue, antialiased: antialiased)
	}
}

extension RoundedRectangle {

	public init(radius: Constants.Radius, style: RoundedCornerStyle = .circular) {
		self.init(cornerRadius: radius.rawValue, style: style)
	}
}

// MARK: - Constants.Padding

extension Constants {

	/// Константы для паддингов, отступов и тд
	public enum Padding: CGFloat {

		/// 2pt
		case p2 = 2

		/// 4pt
		case p4 = 4

		/// 8pt
		case p8 = 8

		/// 12pt
		case p12 = 12

		/// 16pt
		case p16 = 16

		/// 20pt
		case p20 = 20

		/// 24pt
		case p24 = 24

		/// 28pt
		case p28 = 28
	}
}

extension View {

	public func padding(_ edges: Edge.Set = .all, _ length: Constants.Padding) -> some View {
		padding(edges, length.rawValue)
	}

	public func padding(_ length: Constants.Padding) -> some View {
		padding(length.rawValue)
	}
}
