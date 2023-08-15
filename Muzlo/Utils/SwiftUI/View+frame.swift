//
//  View+frame.swift
//  Muzlo
//
//  Created by Georgiy Cheremnykh on 15.08.2023.
//

import SwiftUI

public extension View {

	func frame(size: CGFloat) -> some View {
		frame(width: size, height: size)
	}
}
