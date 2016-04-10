//
//  TwitterClientExtractor.swift
//  HeartExtractor
//
//  Created by 김승호 on 2016. 4. 10..
//  Copyright © 2016년 Seungho Kim. All rights reserved.
//

import Cocoa
import SwifterMac

extension TwitterClient {
	class Extractor: NSObject {
		static func extract(target:Target, success:((Array<Tweet>) -> Void)) {
			switch target {
			case .Tweets:
				extract(target, iteration: 15, maxID: nil, success: success)
				break
			case .Favorite:
				extract(target, iteration: 15, maxID: nil, success: success)
				break
			}
		}
		
		static func extract(target:Target, iteration:Int, maxID:String?, success:((Array<Tweet>) -> Void)) {
			let swifter = Swifter(consumerKey: CONSUMER_KEY, consumerSecret: CONSUMER_SECRET)
			swifter.client.credential = SwifterCredential(accessToken: Auth.token!)
			let fetch: ([JSONValue]?) -> () = {
				guard let statuses = $0 else { return }
				let list: Array<Tweet> = statuses.map { (twt) in
					let tweet = Tweet()
					tweet.id = twt["id_str"].string!
					tweet.name = twt["user"]["name"].string!
					tweet.text = twt["text"].string!
					if twt["extended_entities"]["media"].array != nil {
						tweet.urls = twt["extended_entities"]["media"].array!.map { (url) in
							return NSURL(string: url["media_url"].string!)!
						}
					} else if twt["entities"]["media"].array != nil {
						tweet.urls = twt["entities"]["media"].array!.map { (url) in
							return NSURL(string: url["media_url"].string!)!
						}
					} else {
						tweet.urls = []
					}
					return tweet
				}
				if iteration > 0 && list.last?.id != maxID {
					extract(target, iteration: iteration - 1, maxID: list.last?.id, success: success)
					success(list)
				}
			}
			let handleError: (NSError) -> () = {
				let error = $0
				if error.code == 429 {
					let alert = NSAlert()
					alert.messageText = "API limit"
					alert.informativeText = "try it later."
					alert.runModal()
				} else {
					debugPrint(error)
				}
			}
			switch target {
			case .Favorite:
				swifter.getFavoritesListWithCount(200, sinceID: nil, maxID: maxID, success: fetch, failure: handleError)
				break
			case .Tweets:
				swifter.getStatusesHomeTimelineWithCount(200, sinceID: nil, maxID: maxID, trimUser: nil, contributorDetails: nil, includeEntities: nil, success: fetch, failure: handleError)
				break
			}
		}
		
	}
}
