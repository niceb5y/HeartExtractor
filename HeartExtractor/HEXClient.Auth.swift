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
				guard let EncryptedKey = defaults.string(forKey: "twtKey"),
					let EncryptedSecret = defaults.string(forKey: "twtSecret") else {
						return nil
				}
				guard let key = Encryption.decryptAES256(string: EncryptedKey),
					let secret = Encryption.decryptAES256(string: EncryptedSecret) else {
						return nil
				}
				return (key: key, secret: secret)
			}
			set(token) {
				let defaults = UserDefaults.standard
				let key = Encryption.encryptAES256(string: token!.key)
				let secret = Encryption.encryptAES256(string: token!.secret)
				defaults.set(key, forKey: "twtKey")
				defaults.set(secret, forKey: "twtSecret")
				defaults.synchronize()
			}
		}

		
		static var tokenX: Credential.OAuthAccessToken? {
			get {
				let defaults = UserDefaults.standard
				guard let EncryptedKey = defaults.string(forKey: "twtKey"),
					let EncryptedSecret = defaults.string(forKey: "twtSecret") else {
						return nil
				}
				guard let key = Encryption.decryptAES256(string: EncryptedKey),
					let secret = Encryption.decryptAES256(string: EncryptedSecret) else {
						return nil
				}
				return Credential.OAuthAccessToken(key: key, secret: secret)
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
							fullfill((
								key: Encryption.encryptAES256(string: (accessToken?.key)!)!,
								secret: Encryption.encryptAES256(string: (accessToken?.secret)!)!
							))
						}, failure: { (error) in
							reject(error)
						}
					)
				}
			}
		}
		
		static func clearToken() {
			let defaults = UserDefaults.standard
			defaults.removeObject(forKey: "twtKey")
			defaults.removeObject(forKey: "twtSecret")
			defaults.synchronize()
		}
	}
}
