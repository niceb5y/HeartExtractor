//
//  TwitterClient.swift
//  HeartExtractor
//
//  Created by 김승호 on 2016. 4. 8..
//  Copyright © 2016 Seungho Kim. All rights reserved.
//

import Cocoa

/**
TwitterClient class for twitter image scrapping
*/
class TwitterClient: NSObject {
	static let CONSUMER_KEY = "iEUgj3nj29U592uLZpA181Daq"
	static let CONSUMER_SECRET = "yvxMEdIFdHqvZeURxsPScF0s4juy9wbrQrXaFAlGegjZsdQNwe"
	
	let operationQueue = NSOperationQueue()
	var limitsLeft:[Int] = [15, 15]
	
	/**
	TwitterClient Target
	* Favorites
	* Tweets
	*/
	enum Target: Int {
		case Favorites, Tweets
	}
	
	override init() {
		super.init()
		Fetch.fetchLimits { (_favorites, _tweets) in
			self.limitsLeft = [_favorites, _tweets]
		}
	}
	
	func downloadFiles(target: Target, completion:(() -> ())?) {
		var _maxID:String?
		func download(urls:Array<NSURL>, maxID:String) {
			for url in urls {
				let urls = url.absoluteString
				if urls.hasPrefix("http://pbs.twimg.com/") {
					let newURL = NSURL(string: urls + ":orig")
					if !DataController.contains(newURL!) {
						self.operationQueue.addOperation(TwitterClient.Downloader(url: newURL!, completion: { (path, error) in
							
						}))
						DataController.insert(newURL!)
					}
				}
			}
			_maxID = maxID
			if limitsLeft[target.rawValue] > 0 {
				limitsLeft[target.rawValue] -= 1
				TwitterClient.Fetch.fetch(target, maxID: _maxID, completion: download)
			}
			
		}
		if limitsLeft[target.rawValue] > 0 {
			limitsLeft[target.rawValue] -= 1
			TwitterClient.Fetch.fetch(target, maxID: nil, completion: download)
		} else {
			let alert = NSAlert()
			alert.informativeText = "API Limit"
			alert.messageText = "Try it later"
			alert.runModal()
		}
	}
}
