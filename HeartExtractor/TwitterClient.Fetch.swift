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
	/**
	Fetch class for TwitterClient
	*/
	class Fetch: NSObject {
		static func fetchLimits(completion:(favorites:Int, tweets:Int) -> ()) {
			let swifter = Swifter(consumerKey: CONSUMER_KEY, consumerSecret: CONSUMER_SECRET)
			swifter.client.credential = SwifterCredential(accessToken: Auth.token!)
			swifter.getRateLimitsForResources(["statuses", "favorites"], success: {(resources) in
				let _favorites = resources!["resources"]!["favorites"]["/favorites/list"]["remaining"].integer!
				let _tweets = resources!["resources"]!["statuses"]["/statuses/home_timeline"]["remaining"].integer!
				completion(favorites: _favorites, tweets: _tweets)
			}, failure: {(error) in
				debugPrint(error)
			})
		}
		
		static func fetch(target: Target, maxID: String?, completion:(Array<NSURL>, String) -> ()) {
			let swifter = Swifter(consumerKey: CONSUMER_KEY, consumerSecret: CONSUMER_SECRET)
			swifter.client.credential = SwifterCredential(accessToken: Auth.token!)
			var urls: Array<NSURL> = []
			let fetchTweet: ([JSONValue]?) -> () = {
				guard let tweets = $0 else { return }
				for tweet in tweets {
					let extended_media = tweet["extended_entities"]["media"].array
					let media = tweet["entities"]["media"].array
					if extended_media != nil {
						for url in extended_media! {
							urls.append(NSURL(string: url["media_url"].string!)!)
						}
					} else if media != nil {
						for url in media! {
							urls.append(NSURL(string: url["media_url"].string!)!)
						}
					}
				}
				if tweets.count > 0 {
					let _maxID = tweets.last!["id_str"].string!
					if maxID == _maxID {
						return
					}
					let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
					dispatch_async(queue, {
						completion(urls, _maxID)
					})
				}
			}
			let handleError: (NSError) -> () = {
				debugPrint($0)
			}
			switch target {
			case .Favorites:
				swifter.getFavoritesListWithCount(200, sinceID: nil, maxID: maxID, success: fetchTweet, failure: handleError)
				break
			case .Tweets:
				swifter.getStatusesHomeTimelineWithCount(200, sinceID: nil, maxID: maxID, trimUser: nil, contributorDetails: nil, includeEntities: nil, success: fetchTweet, failure: handleError)
				break
			}
		}
	}
}
