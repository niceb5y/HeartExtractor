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
	
	override func viewDidLoad() {
		super.viewDidLoad()
		if TwitterClient.Auth.token == nil {
			TwitterClient.Auth.createToken()
		}
	}
	
	func printLog(string:String) {
		textView.string? += string + "\n\n"
		scrollToBottom()
	}
	
	func completeFetch(tweet:TwitterClient.Tweet) {
		printLog(tweet.name + "\n" + tweet.text)
	}
	
	func completeDownload(string:String) {
		printLog("[File downloaded: \(string)]")
	}
	
	func skipDownload(string:String) {
		printLog("[File skipped: \(string)]")
	}
	
	func scrollToBottom() {
		let newScrollOrigin:NSPoint?
		guard let view = scrollView.documentView else {
			return
		}
		if view.flipped! {
			newScrollOrigin = NSMakePoint(0.0, NSMaxY(view.frame))
		} else {
			newScrollOrigin = NSMakePoint(0.0, 0.0)
		}
		view.scrollPoint(newScrollOrigin!)
	}
	
	@IBAction func likeButton_Click(sender: AnyObject) {
		printLog("[target: Like]")
		TwitterClient.downloadFiles(TwitterClient.Target.Favorites, completeFetch: completeFetch, completeDownload: completeDownload, skipDownload: skipDownload)
	}
	
	@IBAction func tweetButton_Click(sender: AnyObject) {
		printLog("[target: Tweet]")
		TwitterClient.downloadFiles(TwitterClient.Target.Tweets, completeFetch: completeFetch, completeDownload: completeDownload, skipDownload: skipDownload)
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

