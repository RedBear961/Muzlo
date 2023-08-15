//
//  Theme.swift
//  Muzlo
//
//  Created by Georgiy Cheremnykh on 13.08.2023.
//

import SwiftUI

public protocol Theme {

	var lightBackground: Color { get }

	var darkBackground: Color { get }

	var lightBorder: Color { get }

	var placeholder: Color { get }

	var primary: Color { get }

	var secondary: Color { get }
}

public final class DarkTheme: Theme {

	public var lightBackground: Color {
		Color(hex: "222222")
	}

	public var darkBackground: Color {
		Color(hex: "141414")
	}

	public var lightBorder: Color {
		Color(hex: "555555")
	}

	public var placeholder: Color {
		Color(hex: "454545")
	}

	public var primary: Color {
		.white
	}

	public var secondary: Color {
		.gray
	}
}
