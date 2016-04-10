//
//  TwitterClientAuth.swift
//  HeartExtractor
//
//  Created by 김승호 on 2016. 4. 10..
//  Copyright © 2016년 Seungho Kim. All rights reserved.
//

import Cocoa
import SwifterMac

extension TwitterClient {
	class Auth: NSObject {
		static var token: SwifterCredential.OAuthAccessToken? {
			get {
				let defaults = NSUserDefaults.standardUserDefaults()
				guard let EncryptedKey = defaults.stringForKey("twtKey"),
					EncryptedSecret = defaults.stringForKey("twtSecret") else {
						return nil
				}
				guard let key = Encryption.decryptAES256(EncryptedKey),
					secret = Encryption.decryptAES256(EncryptedSecret) else {
						return nil
				}
				return SwifterCredential.OAuthAccessToken(key: key, secret: secret)
			}
		}
		
		static func createToken() {
			let swifter = Swifter(consumerKey: TwitterClient.CONSUMER_KEY, consumerSecret: TwitterClient.CONSUMER_SECRET)
			swifter.authorizeWithCallbackURL(NSURL(string: "hext://success")!,success: { (accessToken, response) in
					let defaults = NSUserDefaults.standardUserDefaults()
					let key = Encryption.encryptAES256((accessToken?.key)!)
					let secret = Encryption.encryptAES256((accessToken?.secret)!)
					defaults.setObject(key, forKey: "twtKey")
					defaults.setObject(secret, forKey: "twtSecret")
					defaults.synchronize()
				}, failure: { (error) in
					print(error)
			})
		}
		
		static func clearToken() {
			let defaults = NSUserDefaults.standardUserDefaults()
			defaults.removeObjectForKey("twtKey")
			defaults.removeObjectForKey("twtSecret")
			defaults.synchronize()
		}
	}
}
