//
//  Fetcheble.swift
//  Muzlo
//
//  Created by Georgiy Cheremnykh on 19.08.2023.
//

import CoreData

public protocol Fetcheble where Self: NSManagedObject {

	static func fetchRequest() -> NSFetchRequest<Self>
}

extension Fetcheble {

	public static func fetchRequest() -> NSFetchRequest<Self> {
		NSFetchRequest(entityName: String(describing: self))
	}
}
