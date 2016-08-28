//
//  HEXClient.Auth.swift
//  HeartExtractor
//
//  Created by 김승호 on 2016. 8. 18..
//  Copyright © 2016년 Seungho Kim. All rights reserved.
//

import Foundation
import PromiseKit
import SwifterMac

extension HEXClient {

	class Auth: NSObject {
		
		typealias Token = (key: String, secret: String)
		
		static var token: Token? {
			get {
				let defaults = UserDefaults.standard
				guard let encryptedKey = defaults.data(forKey: "hextKey"),
					let encryptedSecret = defaults.data(forKey: "hextSecret") else {
						return nil
				}
				let key = Encryption.decryptAES256(encrypted: encryptedKey)
				let secret = Encryption.decryptAES256(encrypted: encryptedSecret)
				return (key: key, secret: secret)
			}
			set(aToken) {
				let defaults = UserDefaults.standard
				guard let key = aToken?.key,
					let secret = aToken?.secret else {
						return
				}
				let encryptedKey = Encryption.encryptAES256(plain: key)
				let encryptedSecret = Encryption.encryptAES256(plain: secret)
				defaults.set(encryptedKey, forKey: "hextKey")
				defaults.set(encryptedSecret, forKey: "hextSecret")
				defaults.synchronize()
			}
		}
		
		static func getToken() -> Promise<Token> {
			return Promise { (fullfill, reject) in
				if (token != nil) {
					fullfill(token!)
				} else {
					let swifter = Swifter(consumerKey: HEXClient.CONSUMER_KEY, consumerSecret: HEXClient.CONSUMER_SECRET)
					swifter.authorize(
						with: URL(string: "hext://success")!,
						success: { (accessToken, response) in
							token = (key: (accessToken?.key)!, secret: (accessToken?.secret)!)
							fullfill(token!)
						}, failure: { (error) in
							reject(error)
						}
					)
				}
			}
		}
		
		static func clearToken() {
			let defaults = UserDefaults.standard
			defaults.removeObject(forKey: "hextKey")
			defaults.removeObject(forKey: "hextSecret")
			defaults.synchronize()
		}
	}
}
