//
//  TwitterClientEncryption.swift
//  HeartExtractor
//
//  Created by 김승호 on 2016. 4. 10..
//  Copyright © 2016 Seungho Kim. All rights reserved.
//

import Cocoa
import CryptoSwift

extension TwitterClient {
	/**
	Encryption class for TwitterClient
	*/
	class Encryption: NSObject {
		static let KEY = "2553cb4c3833e39e1a82a8c448cf889f"
		static let IV = "98d1ee979c82f33e"
		
		/**
		Encrypt string by AES256
		- parameters:
			- string: String to encrypt
		- returns: AES256 encrypted string
		*/
		static func encryptAES256(string: String) -> String? {
			do {
				return try string.encrypt(AES(key: KEY, iv: IV)).toBase64()!
			} catch let error as NSError {
				debugPrint(error)
			}
			return nil
		}
		
		/**
		Decrypt string by AES256
		- parameters:
			- string: AES256 encrypted string to decrypt
		- returns: Plain string
		*/
		static func decryptAES256(string: String) -> String? {
			do {
				return try string.decryptBase64ToString(AES(key: KEY, iv: IV))
			} catch let error as NSError {
				debugPrint(error)
			}
			return nil
		}
	}

}
