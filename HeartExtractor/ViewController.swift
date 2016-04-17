//
//  ViewController.swift
//  HeartExtractor
//
//  Created by 김승호 on 2016. 4. 7..
//  Copyright © 2016 Seungho Kim. All rights reserved.
//

import Cocoa
import SwifterMac

class ViewController: NSViewController {
	@IBOutlet var textView: NSTextView!
	@IBOutlet weak var scrollView: NSScrollView!
	
	let twitterClient = TwitterClient()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		if TwitterClient.Auth.token == nil {
			TwitterClient.Auth.createToken()
		}
	}
	
	@IBAction func likeButton_Click(sender: AnyObject) {
		let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
		dispatch_async(queue) {
			self.twitterClient.downloadFiles(TwitterClient.Target.Favorites, completion: nil)
		}
	}
	
	@IBAction func tweetButton_Click(sender: AnyObject) {
		let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
		dispatch_async(queue) {
			self.twitterClient.downloadFiles(TwitterClient.Target.Tweets, completion: nil)
		}
	}
	
	@IBAction func clearSession(sender: AnyObject) {
		TwitterClient.Auth.clearToken()
		TwitterClient.Auth.createToken()
		TwitterClient.DataController.deleteAll()
	}

	override var representedObject: AnyObject? {
		didSet {
		// Update the view, if already loaded.
		}
	}
}

