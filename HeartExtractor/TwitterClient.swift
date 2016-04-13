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
	
	/**
	Download media files from twitter
	- parameters:
		- target: Targets to download
		- completeFetch: Things to do after tweet fetch
		- completeDownload: Things to do after download file in url
		- skipDownload: Things to do after skip download file in url
	*/
	func downloadFiles(target:Target, completeFetch:(Tweet) -> () , completeDownload:(String) -> (), skipDownload:(String) -> ()) {
		func download(tweets:Array<Tweet>) {
			for tweet in tweets {
				completeFetch(tweet)
				for url in tweet.urls {
					let urls = url.absoluteString
					if urls.hasPrefix("http://pbs.twimg.com/") {
						let newURL = NSURL(string: urls + ":orig")
						if DataController.contains(newURL!) {
							skipDownload((newURL?.absoluteString)!)
						} else {
							self.operationQueue.addOperation(TwitterClient.Downloader(url: newURL!, completion: { (path, error) in
								completeDownload((newURL?.absoluteString)!)
							}))
							DataController.insert(newURL!)
						}
					}
				}
			}
			if limitsLeft[target.rawValue] > 0 && tweets.count == 200 {
				limitsLeft[target.rawValue] -= 1
				operationQueue.addOperation(TwitterClient.Fetch.FetchOperation(target: target, maxID: nil, completion: download))
			}

		}
		if limitsLeft[target.rawValue] > 0 {
			limitsLeft[target.rawValue] -= 1
			operationQueue.addOperation(TwitterClient.Fetch.FetchOperation(target: target, maxID: nil, completion: download))
		} else {
			let alert = NSAlert()
			alert.informativeText = "API Limit"
			alert.messageText = "Try it later"
			alert.runModal()
		}
	}
}
