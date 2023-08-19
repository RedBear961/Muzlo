//
//  Mediateka.swift
//  Muzlo
//
//  Created by Georgiy Cheremnykh on 19.08.2023.
//

import Foundation

public final class Mediateka: ObservableObject {

	@ManagedObjectContext private var context

	@Published public var tracks: [Track] = []

	public init() {
		self.tracks = try! context.fetch(Track.fetchRequest())
	}

	public func append(tracks: [Track]) {
		Task { @MainActor in
			self.tracks.append(contentsOf: tracks)
		}
	}
}
