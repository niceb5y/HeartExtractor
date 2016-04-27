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
	var fetchCompleted = false
	
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
	
	/**
	Download images from Twitter
	- parameters:
		- target: Target to fetch
		- completion: Block to excute when download completed
	*/
	func downloadFiles(target: Target, completion:(() -> ())? = nil) {
		var _maxID:String?
		fetchCompleted = false
		func download(urls:Array<NSURL>, maxID:String, isFinalFetch:Bool) {
			if isFinalFetch {
				fetchCompleted = true
			}
			for url in urls {
				let urls = url.absoluteString
				if urls.hasPrefix("http://pbs.twimg.com/") {
					let newURL = NSURL(string: urls + ":orig")
					if !DataController.contains(newURL!) {
						self.operationQueue.addOperation(TwitterClient.Downloader(url: newURL!, completion: { (path) in
							if self.operationQueue.operationCount <= 1 && self.fetchCompleted {
								if completion != nil {
									completion!()
								}
							}
						}))
						DataController.insert(newURL!)
					}
				}
			}
			_maxID = maxID
			if limitsLeft[target.rawValue] > 0 && !isFinalFetch {
				limitsLeft[target.rawValue] -= 1
				TwitterClient.Fetch.fetch(target, maxID: _maxID, completion: download)
			} else {
				fetchCompleted = true
				if operationQueue.operationCount <= 1 {
					completion!()
				}
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
			completion!()
		}
	}
}
