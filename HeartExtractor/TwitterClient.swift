//
//  TwitterClient.swift
//  HeartExtractor
//
//  Created by 김승호 on 2016. 4. 8..
//  Copyright © 2016년 Seungho Kim. All rights reserved.
//

import Cocoa

class TwitterClient: NSObject {
	static let CONSUMER_KEY = "iEUgj3nj29U592uLZpA181Daq"
	static let CONSUMER_SECRET = "yvxMEdIFdHqvZeURxsPScF0s4juy9wbrQrXaFAlGegjZsdQNwe"
	
	enum Target: Int {
		case Favorite, Tweets
	}
	
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
		Extractor.extract(target, success: download)
	}
}
