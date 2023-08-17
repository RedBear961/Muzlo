//
// 	Assembly.swift
// 	Dependency
//
// 	Copyright (c) Georgiy Cheremnykh, 2023
//

import Foundation
import Swinject
import SwiftUI

@objcMembers
public class AutoAssembly: NSObject, Assembly {

	public private(set) var container: Container!

	public func assemble(container: Container) {
		self.container = container

		var count = UInt32()
		let pointer = class_copyMethodList(type(of: self), &count)
		let list = Array(UnsafeBufferPointer(start: pointer, count: Int(count)))
		list.forEach { method in
			let selector = method_getName(method)
			guard selector != #selector(NSObject.init),
				  method_getNumberOfArguments(method) == 2,
				  String(cString: method_copyReturnType(method)) == "v" else {
				return
			}

			perform(selector)
		}
	}
}

extension Container {

	public static var `default`: Resolver = {
		var assemblies = [Assembly]()
		Bundle.main.executablePath?.withCString { p in
			var count: UInt32 = 0
			let pointer = objc_copyClassNamesForImage(p, &count)
			let buffer = UnsafeBufferPointer(start: pointer, count: Int(count))
			let classList = buffer.compactMap { name in
				objc_getClass(name) as? AnyClass
			}

			classList.forEach { aClass in
				if let assembly = aClass as? (NSObject & Assembly).Type {
					let instance = assembly.init()
					if type(of: instance) != AutoAssembly.self {
						assemblies.append(instance)
					}
				}
			}
		}

		let container = Container()
		_ = Assembler(assemblies, container: container)
		return container
	}()

	#if DEBUG
	public static func forPreview(_ factory: (Container) -> Void) -> Resolver {
		let container = Container()
		factory(container)
		return container
	}
	#endif
}

@propertyWrapper
public struct Injected<Service> {

	private let service: Service

	public init(name: String? = nil) {
		self.service = Container.default.resolve(Service.self, name: name)!
	}
	
	public var wrappedValue: Service { service }
}

extension Injected where Service == any Resolver {

	public init(name: String? = nil) {
		self.service = Container.default
	}
}

@propertyWrapper
public struct InjectedObject<Service: ObservableObject>: DynamicProperty {

	@ObservedObject private var service: Service

	public init(name: String? = nil) {
		self.service = Container.default.resolve(Service.self, name: name)!
	}

	public var wrappedValue: Service { service }
	public var projectedValue: ObservedObject<Service>.Wrapper { $service }
}

@propertyWrapper
public struct ManagedObjectContext {

	private let context: NSManagedObjectContext

	public init() {
		self.context = Container.default.resolve(CoreDataStorage.self)!.context
	}

	public var wrappedValue: NSManagedObjectContext { context }
}
