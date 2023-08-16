//
//  Stack.swift
//  Muzlo
//
//  Created by Georgiy Cheremnykh on 16.08.2023.
//

import Foundation

public struct Stack<T> {

	enum StackFailure: Error {
		case unknown
	}

	private var objects: [T] = []

	public var isEmpty: Bool {
		objects.isEmpty
	}

	public mutating func append(_ objects: [T]) {
		let reversed = objects.reversed()
		self.objects.append(contentsOf: reversed)
	}

	public mutating func push(_ object: T) {
		objects.append(object)
	}

	public mutating func pop() throws -> T {
		guard let object = objects.popLast() else {
			throw StackFailure.unknown
		}

		return object
	}
}
