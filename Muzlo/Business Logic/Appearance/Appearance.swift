//
//  Appearance.swift
//  Muzlo
//
//  Created by Georgiy Cheremnykh on 13.08.2023.
//

import SwiftUI

public final class Appearance: ObservableObject {

	@Published public private(set) var current: Theme = DarkTheme()
}
