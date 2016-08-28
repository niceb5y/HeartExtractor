//
//  HEXClient.Fetch.swift
//  HeartExtractor
//
//  Created by 김승호 on 2016. 8. 20..
//  Copyright © 2016년 Seungho Kim. All rights reserved.
//

import Foundation
import PromiseKit
import SwifterMac

extension HEXClient{
	class Fetch: NSObject {
		typealias Limit = (favorites:Int, tweets:Int)
		
		static func fetchLimit(token: Auth.Token) -> Promise<(Limit, Auth.Token)> {
			return Promise {(fullfill, reject) in
				let swifterToken = Credential.OAuthAccessToken(key: token.key, secret: token.secret)
				let swifter = Swifter(consumerKey: CONSUMER_KEY, consumerSecret: CONSUMER_SECRET)
				swifter.client.credential = Credential(accessToken: swifterToken)
				swifter.getRateLimits(for: ["statuses", "favorites"], success: {(resources) in
					let favorites = resources["resources"]["favorites"]["/favorites/list"]["remaining"].integer!
					let tweets = resources["resources"]["statuses"]["/statuses/home_timeline"]["remaining"].integer!
					fullfill(((favorites: favorites, tweets: tweets), token))
				}, failure: {(error) in
					reject(error)
				})
			}
		}

		static func fetchURL(target: Target, token: Auth.Token, limits:Limit, maxID: String?) -> Promise<[URL]> {
			func fetch(target: Target, swifter: Swifter, limits: Int, maxID: String?, completion:(([URL]) -> ()), reject:((Error) -> ())) {
				func decreaseStringNumberBy1(number:String?) -> String? {
					guard let number = number else {
						return nil
					}
					var numberArray = number.characters.map { (digit) -> Int in
						return Int(String(digit))!
					}
					numberArray[numberArray.count - 1] -= 1
					for i in (1..<numberArray.count).reversed() {
						if (numberArray[i] < 0) {
							numberArray[i] += 10
							numberArray[i - 1] -= 1
						}
					}
					while (numberArray.first! == 0 && numberArray.count > 1) {
						numberArray.removeFirst()
					}
					let stringArray = numberArray.map { (digit) -> String in
						return String(describing: digit)
					}
					return stringArray.joined()
				}
				
				func successHandler(retults: JSON) {
					let tweets = retults.array!
					if (tweets.count > 0) {
						var fetchedURLs: [URL] = []
						let maxID = tweets.last!["id_str"].string
						for tweet in tweets {
							let extended_media = tweet["extended_entities"]["media"].array
							let media = tweet["entities"]["media"].array
							if extended_media != nil {
								for url in extended_media! {
									fetchedURLs.append(URL(string: url["media_url"].string!)!)
								}
							} else if media != nil {
								for url in media! {
									fetchedURLs.append(URL(string: url["media_url"].string!)!)
								}
							}
						}
						fetch(target: target, swifter: swifter, limits: limits - 1, maxID: decreaseStringNumberBy1(number: maxID), completion: { (urls) in
							completion(fetchedURLs + urls)
						}, reject: reject)
					} else {
						completion([])
					}
				}
				
				if limits < 1 {
					completion([])
				} else {
					switch target {
					case .favorites:
						swifter.getRecentlyFavouritedTweets(count: 200, sinceID: nil, maxID: maxID, success:successHandler, failure: reject)
						break
					case .tweets:
						swifter.getHomeTimeline(count: 200, sinceID: nil, maxID: maxID, trimUser: nil, contributorDetails: nil, includeEntities: nil, success: successHandler, failure: reject)
						break
					}
				}
			}
			
			return Promise {(fullfill, reject) in
				let swifterToken = Credential.OAuthAccessToken(key: token.key, secret: token.secret)
				let swifter = Swifter(consumerKey: CONSUMER_KEY, consumerSecret: CONSUMER_SECRET)
				swifter.client.credential = Credential(accessToken: swifterToken)
				switch target {
				case .favorites:
					fetch(target: target, swifter: swifter, limits: limits.favorites, maxID: maxID, completion: fullfill, reject: reject)
					break
				case .tweets:
					fetch(target: target, swifter: swifter, limits: limits.tweets, maxID: maxID, completion: fullfill, reject: reject)
					break
				}
			}
		}
	}
}
