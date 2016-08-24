//
//  HEXClient.swift
//  HeartExtractor
//
//  Created by 김승호 on 2016. 8. 18..
//  Copyright © 2016년 Seungho Kim. All rights reserved.
//

import Foundation

class HEXClient: NSObject {
	static let CONSUMER_KEY = "iEUgj3nj29U592uLZpA181Daq"
	static let CONSUMER_SECRET = "yvxMEdIFdHqvZeURxsPScF0s4juy9wbrQrXaFAlGegjZsdQNwe"
	
	enum Target: Int {
		case favorites, tweets
	}
}
