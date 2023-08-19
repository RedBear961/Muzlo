//
//  ManagedObjectContext+fetch.swift
//  Muzlo
//
//  Created by Georgiy Cheremnykh on 19.08.2023.
//

import CoreData

extension NSManagedObjectContext {

	public func first<T: Fetcheble>(where format: String, _ args: CVarArg...) throws -> T? {
		let request = T.fetchRequest()
		request.predicate = NSPredicate(format: format, args)
		let results = try fetch(request)
		return results.first
	}
}
