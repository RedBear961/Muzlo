//
//  FileProvider.swift
//  Muzlo
//
//  Created by Georgiy Cheremnykh on 12.08.2023.
//

import Foundation

public protocol FileProvider {

	func copyFile(from url: URL, with id: UUID) throws -> URL
}

public final class FileProviderImpl: FileProvider {

	@Injected private var fileManager: FileManager
	private let appDirectory: String

	public init() {
		self.appDirectory = "/Users/\(NSUserName())/Music/Muzlo/Music Library.muzlodb"
	}

	public func copyFile(from url: URL, with id: UUID) throws -> URL {
		let pathExtension = url.pathExtension
		var newUrl = URL(filePath: appDirectory)
		newUrl.append(component: "\(id.uuidString).\(pathExtension)")
		try fileManager.moveItem(at: url, to: newUrl)
		return newUrl
	}
}
