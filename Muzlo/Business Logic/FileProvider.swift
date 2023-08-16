//
//  FileProvider.swift
//  Muzlo
//
//  Created by Georgiy Cheremnykh on 12.08.2023.
//

import Foundation

public protocol FileProvider {

	func load() throws -> [URL]
}

private let kSupportedFormats = ["mp3"]

public final class FileProviderImpl: FileProvider {

	@Injected private var fileManager: FileManager
	private let appDirectory: String

	public init() {
		self.appDirectory = "/Users/\(NSUserName())/Music/Muzlo"
	}

	var urls: [URL] {
		let fileManager = FileManager.default
		let appDirectory = "/Users/\(NSUserName())/Music/Muzlo"
		if !fileManager.fileExists(atPath: appDirectory) {
			try! fileManager.createDirectory(
				atPath: appDirectory,
				withIntermediateDirectories: true
			)
		}
		let contents = try! fileManager.contentsOfDirectory(atPath: appDirectory)
		return contents.compactMap { file in
			guard let fileExtension = file.split(separator: ".").last,
				  fileExtension == "mp3" else {
				return nil
			}

			return URL(filePath: appDirectory).appending(path: file)
		}
	}

	public func load() throws -> [URL] {
		if !fileManager.fileExists(atPath: appDirectory) {
			try fileManager.createDirectory(
				atPath: appDirectory,
				withIntermediateDirectories: true
			)
		}

		let contents = try fileManager.contentsOfDirectory(atPath: appDirectory)
		return contents.compactMap { file in
			guard let fileExtension = file.split(separator: ".").last,
				  kSupportedFormats.contains(String(fileExtension)) else {
				return nil
			}

			return URL(filePath: appDirectory).appending(path: file)
		}
	}
}
