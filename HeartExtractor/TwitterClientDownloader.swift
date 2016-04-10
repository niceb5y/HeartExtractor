//
//  TwitterClientDownloader.swift
//  HeartExtractor
//
//  Created by 김승호 on 2016. 4. 10..
//  Copyright © 2016년 Seungho Kim. All rights reserved.
//

import Cocoa

extension TwitterClient {
	class Downloader: NSObject {
		static func downloadFile(url: NSURL, completion:(path:String, error:NSError!) -> Void) {
			let documentsUrl =  NSFileManager.defaultManager().URLsForDirectory(.DownloadsDirectory, inDomains: .UserDomainMask).first! as NSURL
			let urls = url.absoluteString.stringByReplacingOccurrencesOfString(":orig", withString: "", options: NSStringCompareOptions.BackwardsSearch, range: nil)
			let destinationUrl = documentsUrl.URLByAppendingPathComponent(NSURL(string: urls)!.lastPathComponent!)
			if NSFileManager().fileExistsAtPath(destinationUrl.path!) {
				completion(path: destinationUrl.path!, error:nil)
			} else if let dataFromURL = NSData(contentsOfURL: url){
				if dataFromURL.writeToURL(destinationUrl, atomically: true) {
					completion(path: destinationUrl.path!, error:nil)
				} else {
					let error = NSError(domain:"Error saving file", code:1001, userInfo:nil)
					completion(path: destinationUrl.path!, error:error)
				}
			} else {
				let error = NSError(domain:"Error downloading file", code:1002, userInfo:nil)
				completion(path: destinationUrl.path!, error:error)
			}
		}
	}
}
