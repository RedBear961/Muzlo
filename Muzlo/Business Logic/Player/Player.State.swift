//
//  Player.State.swift
//  Muzlo
//
//  Created by Georgiy Cheremnykh on 16.08.2023.
//

import Foundation

extension Player {

	public struct State {

		var isPlaying: Bool = false

		var canBack: Bool = false
		var canForward: Bool = false
		var canPlay: Bool = false

		var progress: CGFloat = 0
		var time: String = ""
	}
}
