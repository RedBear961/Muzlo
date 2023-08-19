//
//  Artist.swift
//  Muzlo
//
//  Created by Georgiy Cheremnykh on 19.08.2023.
//

import CoreData

@objc(Artist)
public final class Artist: NSManagedObject, Fetcheble {

	@NSManaged public var name: String
	@NSManaged public var tracks: Set<Track>
	@NSManaged public var albums: Set<Album>

	public func add(track: Track) {
		tracks.insert(track)
	}

	public func add(album: Album) {
		albums.insert(album)
	}
}
