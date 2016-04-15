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
		
		class FetchOperation: NSOperation {
			var _target: Target
			var _maxID: String?
			var _completion: (Array<Tweet>) -> ()
			
			init(target: Target, maxID:String?, completion:(Array<Tweet>) -> ()) {
				_target = target
				_maxID = maxID
				_completion = completion
			}
			
			override func main() {
				let swifter = Swifter(consumerKey: CONSUMER_KEY, consumerSecret: CONSUMER_SECRET)
				swifter.client.credential = SwifterCredential(accessToken: Auth.token!)
				let fetchTweet: ([JSONValue]?) -> () = {
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
					let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
					dispatch_async(queue, { 
						self._completion(list)
					})
				}
				let handleError: (NSError) -> () = {
					debugPrint($0)
				}
				switch _target {
				case .Favorites:
					swifter.getFavoritesListWithCount(200, sinceID: nil, maxID: _maxID, success: fetchTweet, failure: handleError)
					break
				case .Tweets:
					swifter.getStatusesHomeTimelineWithCount(200, sinceID: nil, maxID: _maxID, trimUser: nil, contributorDetails: nil, includeEntities: nil, success: fetchTweet, failure: handleError)
					break
				}
			}
		}
	}
}
