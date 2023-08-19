//
//  ID3Decoder.swift
//  Muzlo
//
//  Created by Georgiy Cheremnykh on 11.08.2023.
//

import Foundation
import SwiftUI
import CoreData

public protocol TrackInfo {

	var name: String { get }
	var duration: String { get }
	var artist: Artist? { get }
	var album: Album? { get }

	var preview: Image { get }
}

@objc(Track)
public final class Track: NSManagedObject, Fetcheble {

	@NSManaged public var name: String
	@NSManaged public var duration: String
	@NSManaged public var id: UUID
	@NSManaged public var url: URL

	@NSManaged public var artist: Artist?
	@NSManaged public var album: Album?
	@NSManaged public var genre: Genre?
}

extension Track: TrackInfo {

	public var preview: Image {
		.album
	}
}

public struct EmptyTrack: TrackInfo {

	public let name: String
	public let duration: String
	public let artist: Artist?
	public let album: Album?
	public let preview: Image

	public init() {
		self.name = ""
		self.duration = ""
		self.artist = nil
		self.album = nil
		self.preview = .album
	}
}
