//
//  CoreDataStorage.swift
//  Muzlo
//
//  Created by Georgiy Cheremnykh on 18.08.2023.
//

import CoreData
import Logger

public protocol CoreDataStorage {

	var context: NSManagedObjectContext { get }
}

public final class CoreDataStorageImpl: CoreDataStorage {

	public var persistentContainer: NSPersistentContainer = {
		let container = NSPersistentContainer(name: "Muzlo")
		container.loadPersistentStores { description, error in
			if let error {
				Logger.shared.assert(true, message: error.localizedDescription)
			}
		}
		return container
	}()

	public var context: NSManagedObjectContext {
		persistentContainer.viewContext
	}
}
