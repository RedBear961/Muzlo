//
//  Asset.swift
//  Muzlo
//
//  Created by Georgiy Cheremnykh on 15.08.2023.
//

import SwiftUI

// MARK: - Player

public extension Image {

	static var play: Image {
		Image(systemName: "play.fill")
	}

	static var pause: Image {
		Image(systemName: "pause.fill")
	}

	static var shuffle: Image {
		Image(systemName: "shuffle")
	}

	static var backward: Image {
		Image(systemName: "backward.fill")
	}

	static var forward: Image {
		Image(systemName: "forward.fill")
	}

	static var `repeat`: Image {
		Image(systemName: "repeat")
	}

	static var album: Image {
		Image("ic_album")
	}

	static var speakerOff: Image {
		Image(systemName: "speaker.fill")
	}

	static var speakerOn: Image {
		Image(systemName: "speaker.wave.3.fill")
	}

	static var lyrics: Image {
		Image(systemName: "textformat")
	}

	static var list: Image {
		Image(systemName: "list.bullet")
	}
}
