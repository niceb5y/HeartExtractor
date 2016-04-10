//
//  TwitterClientDataController.swift
//  HeartExtractor
//
//  Created by 김승호 on 2016. 4. 10..
//  Copyright © 2016 Seungho Kim. All rights reserved.
//

import Cocoa

extension TwitterClient {
	/**
	DataController class for TwitterClient
	*/
	class DataController: NSObject {
		static let managedObjectContext = (NSApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
		
		/**
		Fetch all URLs from DB
		*/
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
		
		/**
		Insert new URL to DB
		- parameters:
			- url: URL to insert
		*/
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
		
		/**
		Delete all URLs from DB
		*/
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
		
		/**
		Check if URL is inside of DB
		- parameters:
			- url: URL to check
		*/
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
