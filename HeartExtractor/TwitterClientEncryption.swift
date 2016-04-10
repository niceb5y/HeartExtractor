//
//  TwitterClientEncryption.swift
//  HeartExtractor
//
//  Created by 김승호 on 2016. 4. 10..
//  Copyright © 2016년 Seungho Kim. All rights reserved.
//

import Cocoa
import CryptoSwift

extension TwitterClient {
	class Encryption: NSObject {
		static let KEY = "2553cb4c3833e39e1a82a8c448cf889f"
		static let IV = "98d1ee979c82f33e"
		
		static func encryptAES256(string: String) -> String? {
			do {
				return try string.encrypt(AES(key: KEY, iv: IV)).toBase64()!
			} catch let error as NSError {
				print(error)
			}
			return nil
		}
		
		static func decryptAES256(string: String) -> String? {
			do {
				return try string.decryptBase64ToString(AES(key: KEY, iv: IV))
			} catch let error as NSError {
				print(error)
			}
			return nil
		}
	}

}
