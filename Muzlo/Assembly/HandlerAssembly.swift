//
//  HandlerAssembly.swift
//  Muzlo
//
//  Created by Georgiy Cheremnykh on 17.08.2023.
//

import Foundation
import Swinject

final class HandlerAssembly: AutoAssembly {

	func dropHandler() {
		container.register(DropHandler.self) { _ in DropHandlerImpl() }
	}
}
