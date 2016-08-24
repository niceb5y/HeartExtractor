//
//  HEXClient.History.swift
//  HeartExtractor
//
//  Created by 김승호 on 2016. 8. 19..
//  Copyright © 2016년 Seungho Kim. All rights reserved.
//

import Cocoa

extension HEXClient {
	
	class History: NSObject {
		
		static let managedObjectContext = (NSApplication.shared().delegate as! AppDelegate).managedObjectContext
		
		static func fetchAll() -> [HistoryEntity] {
			let fetch = NSFetchRequest<HistoryEntity>(entityName: "HistoryEntity")
			do {
				let fetchedHistoryEntities = try managedObjectContext.fetch(fetch)
				return fetchedHistoryEntities
			} catch let error as NSError {
				debugPrint(error)
			}
			return []
		}
		
		static func insert(url:URL) {
			let entity: HistoryEntity = NSEntityDescription.insertNewObject(forEntityName: "HistoryEntity", into: managedObjectContext) as! HistoryEntity
			entity.address = url.absoluteString
			entity.when = Date()
			do {
				try managedObjectContext.save()
			} catch let error as NSError {
				debugPrint(error)
			}
		}
		
		static func deleteAll() {
			let entities = fetchAll()
			for entity in entities {
				managedObjectContext.delete(entity)
			}
			do {
				try managedObjectContext.save()
			} catch let error as NSError {
				debugPrint(error)
			}
		}
		
		static func includes(url:URL) -> Bool {
			let fetch = NSFetchRequest<HistoryEntity>(entityName: "HistoryEntity")
			fetch.predicate = NSPredicate(format: "address == '\(url.absoluteString)'")
			do {
				let fetchedHistoryEntities = try managedObjectContext.fetch(fetch)
				return fetchedHistoryEntities.count > 0
			} catch let error as NSError {
				debugPrint(error)
			}
			return false
		}
	}
}

