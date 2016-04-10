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
	
	/**
	TwitterClient Target
	* Favorites
	* Tweets
	*/
	enum Target: Int {
		case Favorites, Tweets
	}
	
	/**
	Download media files from twitter
	- parameters:
		- target: Targets to download
		- completeFetch: Things to do after tweet fetch
		- completeDownload: Things to do after download file in url
		- skipDownload: Things to do after skip download file in url
	*/
	static func downloadFiles(target:Target, completeFetch:(Tweet) -> () , completeDownload:(String) -> (), skipDownload:(String) -> ()) {
		let download:(Array<Tweet>) -> () = {
			let tweets = $0
			for tweet in tweets {
				for url in tweet.urls {
					let urls = url.absoluteString
					if urls.hasPrefix("http://pbs.twimg.com/") {
						let newURL = NSURL(string: urls + ":orig")
						if DataController.contains(newURL!) {
							skipDownload((newURL?.absoluteString)!)
						} else {
							TwitterClient.Downloader.downloadFile(newURL!, completion: { (path, error) in
								completeDownload((newURL?.absoluteString)!)
							})
							DataController.insert(newURL!)
						}
					}
				}
				completeFetch(tweet)
			}
		}
		Fetch.fetch(target, success: download)
	}
}
