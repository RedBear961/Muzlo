//
//  Album.swift
//  Muzlo
//
//  Created by Georgiy Cheremnykh on 19.08.2023.
//

import CoreData

@objc(Album)
public final class Album: NSManagedObject, Fetcheble {

	@NSManaged public var name: String
	@NSManaged public var artist: Artist
	@NSManaged public var tracks: Set<Track>

	public func add(track: Track) {
		tracks.insert(track)
	}
}
