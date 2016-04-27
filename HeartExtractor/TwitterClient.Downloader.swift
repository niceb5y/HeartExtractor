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
		var completion: (String) -> ()
		
		init(url: NSURL, completion:(path:String) -> Void) {
			self.url = url
			documentsUrl =  NSFileManager.defaultManager().URLsForDirectory(.DownloadsDirectory, inDomains: .UserDomainMask).first! as NSURL
			let urls = url.absoluteString.stringByReplacingOccurrencesOfString(":orig", withString: "", options: NSStringCompareOptions.BackwardsSearch, range: nil)
			destinationUrl = documentsUrl!.URLByAppendingPathComponent(NSURL(string: urls)!.lastPathComponent!)
			self.completion = completion
		}
		
		override func main() {
			if NSFileManager().fileExistsAtPath(destinationUrl!.path!) {
				debugPrint("File already exists.")
			} else if let dataFromURL = NSData(contentsOfURL: url!) {
				if dataFromURL.writeToURL(destinationUrl!, atomically: true) {
					completion(destinationUrl!.path!)
				} else {
					debugPrint("Error saving file.")
				}
			} else {
				debugPrint("Error downloading file.")
			}
		}
	}
}
