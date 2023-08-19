//
//  Genre.swift
//  Muzlo
//
//  Created by Georgiy Cheremnykh on 19.08.2023.
//

import CoreData

@objc(Genre)
public final class Genre: NSManagedObject, Fetcheble {

	@NSManaged public var name: String
	@NSManaged public var tracks: Set<Track>
}
