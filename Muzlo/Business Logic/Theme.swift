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
	
	var textFieldBorder: Color { get}
}

public final class DarkTheme: Theme {

	public var lightBackground: Color {
		Color(hex: "141414")
	}

	public var darkBackground: Color {
		Color(hex: "222222")
	}

	public var textFieldBorder: Color {
		Color(hex: "555555")
	}
}
