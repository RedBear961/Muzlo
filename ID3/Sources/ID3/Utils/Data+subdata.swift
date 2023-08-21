//
//  Data+subdata.swift
//  
//
//  Created by Georgiy Cheremnykh on 12.08.2023.
//

import Foundation

public protocol ExpressibleByArray<Element> {

	associatedtype Element

	init?(_ array: [Element])
}

extension Data {

	public struct ComponentIterator {

		private var data: Data

		fileprivate init(data: Data) {
			self.data = data
		}

		public mutating func next<T>(_ type: T.Type) -> T {
			let size = MemoryLayout<T>.size
			let value = data.withUnsafeBytes { buffer in
				buffer
					.baseAddress!
					.assumingMemoryBound(to: type)
					.pointee
			}
			data = data.subdata(from: size)
			return value
		}

		public mutating func next<T, Output: OptionSet>(
			_ type: T.Type,
			bind to: Output.Type = Output.self
		) -> Output where Output.RawValue == T {
			Output(rawValue: next(type))
		}

		public mutating func next<T>(arrayOf type: T.Type, count: Int) -> [T] {
			let size = MemoryLayout<T>.size * count
			let value = data.withUnsafeBytes { buffer in
				let pointer = buffer
					.baseAddress!
					.bindMemory(to: type, capacity: count)

				let buffer = UnsafeBufferPointer(
					start: pointer,
					count: count
				)
				return Array(buffer)
			}
			data = data.subdata(from: size)
			return value
		}

		public mutating func next<T, Output: ExpressibleByArray>(
			arrayOf type: T.Type,
			count: Int,
			bind to: Output.Type = Output.self
		) throws -> Output where Output.Element == T {
			let array = next(arrayOf: type, count: count)
			return Output(array)!
		}

		public mutating func next(before byte: UInt8) -> [UInt8]? {
			guard let index = data.firstIndex(of: byte) else {
				return nil
			}

			let subdata = data[..<index]
			data = data[index...]
			return [UInt8](subdata)
		}

		public mutating func advance(by amount: Int) {
			data = data.advanced(by: amount)
		}
	}

	public func componentIterator() -> ComponentIterator {
		ComponentIterator(data: self)
	}

	public func subdata(from location: Int, count: Int) -> Data {
		subdata(in: location..<location + count)
	}

	public func subdata(from location: Int) -> Data {
		subdata(in: location..<count)
	}

	public func subdata(to byte: UInt8) -> Data? {
		guard let index = firstIndex(of: byte) else { return nil }
		return self[...index]
	}

	public func assuming<T: Numeric>(to: T.Type) -> T {
		var value: T = 0
		let range = NSRange(
			location: 0,
			length: MemoryLayout<T>.size
		)
		(self as NSData).getBytes(&value, range: range)
		return value
	}

	public func bytes(count: Int) -> [UInt8] {
		[UInt8](subdata(in: 0..<count))
	}
}

extension Data.ComponentIterator {

	public mutating func textEncoding() -> String.Encoding? {
		let marker = next(UInt8.self)
		switch marker {
		case 0x0:	return .isoLatin1
		case 0x1:	return .utf16
		case 0x3:	return .utf8
		default:
			return nil
		}
	}

	public mutating func text(encoding: String.Encoding) -> String? {
		guard let bytes = next(before: 0x0),
			  let text = String(data: Data(bytes), encoding: encoding) else {
			return nil
		}

		advance(by: 1)
		return text
	}
}
