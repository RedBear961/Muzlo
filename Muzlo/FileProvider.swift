//
//  FileProvider.swift
//  Muzlo
//
//  Created by Georgiy Cheremnykh on 12.08.2023.
//

import Foundation

final class FileProvider {

	static let shared = FileProvider()

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
}
