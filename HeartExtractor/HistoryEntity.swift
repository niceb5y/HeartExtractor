//
//  HistoryEntity.swift
//  HeartExtractor
//
//  Created by 김승호 on 2016. 4. 10..
//  Copyright © 2016 Seungho Kim. All rights reserved.
//

import Foundation
import CoreData


class HistoryEntity: NSManagedObject {

	@NSManaged var when: NSDate?
	@NSManaged var address: String?

}
