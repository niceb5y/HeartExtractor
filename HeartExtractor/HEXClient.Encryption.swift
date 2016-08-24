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
		
		static func encryptAES256(string: String) -> String? {
			
			return try? string.encrypt(cipher: AES(key: KEY, iv: IV))
		}
		
		static func decryptAES256(string: String) -> String? {
			return try? string.decryptBase64ToString(cipher: AES(key: KEY, iv: IV))
		}
	}
}
