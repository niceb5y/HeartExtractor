//
//  HEXClient.Encryption.swift
//  HeartExtractor
//
//  Created by 김승호 on 2016. 8. 18..
//  Copyright © 2016년 Seungho Kim. All rights reserved.
//

import Foundation
import CryptoSwift

extension HEXClient {
	
	class Encryption: NSObject {
		
		static let KEY = "2553cb4c3833e39e1a82a8c448cf889f"
		static let IV = "98d1ee979c82f33e"
		
		static func encryptAES256(plain: String) -> Data {
			let bytes = plain.utf8.map({$0})
			let encrypted = try! bytes.encrypt(cipher: AES(key: KEY, iv: IV))
			return Data(bytes: encrypted)
		}
		
		static func decryptAES256(encrypted: Data) -> String {
			let bytes = encrypted.bytes
			let decrypted = try! bytes.decrypt(cipher: AES(key: KEY, iv: IV))
			return String(bytes: decrypted, encoding: String.Encoding.utf8)!
		}
	}
}
