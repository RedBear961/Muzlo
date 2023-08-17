//
//  ID3Decoder.swift
//  Muzlo
//
//  Created by Georgiy Cheremnykh on 11.08.2023.
//

import Foundation
import SwiftUI
import CoreData

public final class Track: NSManagedObject {

	@NSManaged public var name: String
	@NSManaged public var duration: String
	@NSManaged public var id: UUID
	@NSManaged public var url: URL
}

public final class Artist: NSManagedObject {

	@NSManaged public var name: String
}

public final class Genre: NSManagedObject {

	@NSManaged public var name: String
}

public final class Album: NSManagedObject {

	@NSManaged public var name: String
}

public struct TrackInfo {

	public let title: String
	public let artist: String
	public let duration: String
	public let album: Image
	public let url: URL

	public static var empty: TrackInfo {
		TrackInfo(
			title: "",
			artist: "",
			duration: "",
			album: .album,
			url: URL(string: "http://yourmom.zip")!
		)
	}
}
