//
//  TwitterClientTweet.swift
//  HeartExtractor
//
//  Created by 김승호 on 2016. 4. 10..
//  Copyright © 2016년 Seungho Kim. All rights reserved.
//

import Cocoa

extension TwitterClient {
	class Tweet: NSObject {
		var id:String = ""
		var name:String = ""
		var text:String = ""
		var urls:Array<NSURL> = []
	}
}