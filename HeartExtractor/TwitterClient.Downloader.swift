//
//  TwitterClientDownloader.swift
//  HeartExtractor
//
//  Created by 김승호 on 2016. 4. 10..
//  Copyright © 2016 Seungho Kim. All rights reserved.
//

import Cocoa

extension TwitterClient {
	/**
	Downloader class for TwitterClient
	*/
	class Downloader: NSOperation {
		var url: NSURL?
		var documentsUrl: NSURL?
		var destinationUrl: NSURL?
		var completion: (String, NSError!) -> ()?
		
		init(url: NSURL, completion:(path:String, error:NSError!) -> Void) {
			self.url = url
			documentsUrl =  NSFileManager.defaultManager().URLsForDirectory(.DownloadsDirectory, inDomains: .UserDomainMask).first! as NSURL
			let urls = url.absoluteString.stringByReplacingOccurrencesOfString(":orig", withString: "", options: NSStringCompareOptions.BackwardsSearch, range: nil)
			destinationUrl = documentsUrl!.URLByAppendingPathComponent(NSURL(string: urls)!.lastPathComponent!)
			self.completion = completion
		}
		
		override func main() {
			if NSFileManager().fileExistsAtPath(destinationUrl!.path!) {
				completion(destinationUrl!.path!, nil)
			} else if let dataFromURL = NSData(contentsOfURL: url!){
				if dataFromURL.writeToURL(destinationUrl!, atomically: true) {
					completion(destinationUrl!.path!, nil)
				} else {
					let error = NSError(domain:"Error saving file", code:1001, userInfo:nil)
					completion(destinationUrl!.path!, error)
				}
			} else {
				let error = NSError(domain:"Error downloading file", code:1002, userInfo:nil)
				completion(destinationUrl!.path!, error)
			}
		}
	}
}
