//
//  TwitterClientDataController.swift
//  HeartExtractor
//
//  Created by 김승호 on 2016. 4. 10..
//  Copyright © 2016년 Seungho Kim. All rights reserved.
//

import Cocoa

extension TwitterClient {
	class DataController: NSObject {
		static let managedObjectContext = (NSApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
		
		static func fetchAll() -> [HistoryEntity] {
			let fetch = NSFetchRequest(entityName: "HistoryEntity")
			do {
				let fetchedHistoryEntities = try managedObjectContext.executeFetchRequest(fetch) as! [HistoryEntity]
				return fetchedHistoryEntities
			} catch let error as NSError {
				debugPrint(error)
			}
			return []
		}
		
		static func insert(url:NSURL) {
				let entity: HistoryEntity = NSEntityDescription.insertNewObjectForEntityForName("HistoryEntity", inManagedObjectContext: managedObjectContext) as! HistoryEntity
				entity.address = url.absoluteString
				entity.when = NSDate()
				do {
					try managedObjectContext.save()
				} catch let error as NSError {
					debugPrint(error)
				}
		}
		
		static func deleteAll() {
			let entities = fetchAll()
			for entity in entities {
				managedObjectContext.deleteObject(entity)
			}
			do {
				try managedObjectContext.save()
			} catch let error as NSError {
				debugPrint(error)
			}
		}
		
		static func contains(url:NSURL) -> Bool {
			let fetch = NSFetchRequest(entityName: "HistoryEntity")
			fetch.predicate = NSPredicate(format: "address == '\(url.absoluteString)'")
			do {
				let fetchedHistoryEntities = try managedObjectContext.executeFetchRequest(fetch) as! [HistoryEntity]
				return fetchedHistoryEntities.count > 0
			} catch let error as NSError {
				debugPrint(error)
			}
			return false
		}
	}
}
