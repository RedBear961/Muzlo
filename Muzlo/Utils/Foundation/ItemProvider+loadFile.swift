//
//  ItemProvider+loadFile.swift
//  Muzlo
//
//  Created by Georgiy Cheremnykh on 17.08.2023.
//

import Foundation
import UniformTypeIdentifiers

public typealias ItemProvider = NSItemProvider

extension ItemProvider {

	public func hasItemConforming(to type: UTType) -> Bool {
		hasItemConformingToTypeIdentifier(type.identifier)
	}

	public func loadFileRepresentation(for type: UTType) async throws -> URL {
		try await withCheckedThrowingContinuation { continuation in
			loadFileRepresentation(forTypeIdentifier: type.identifier) { url, error in
				guard let url else {
					continuation.resume(with: .failure(error!))
					return
				}
				continuation.resume(with: .success(url))
			}
		}
	}
}

extension NSItemProvider: @unchecked Sendable {
}
