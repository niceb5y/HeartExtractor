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
	@IBOutlet weak var indicator: NSProgressIndicator!
	
	let twitterClient = TwitterClient()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		if TwitterClient.Auth.token == nil {
			TwitterClient.Auth.createToken()
		}
	}
	
	func completion() {
		indicator.stopAnimation(self)
		let alert = NSAlert()
		alert.addButtonWithTitle(NSLocalizedString("OK", comment: "OK"))
		alert.addButtonWithTitle(NSLocalizedString("Quit", comment: "Quit"))
		alert.messageText = "Heart Extractor"
		alert.informativeText = NSLocalizedString("TaskComplete", comment: "TaskComplete")
		alert.alertStyle = NSAlertStyle.InformationalAlertStyle
		alert.beginSheetModalForWindow(NSApp.mainWindow!) { (response) in
			if response == NSAlertSecondButtonReturn {
				NSApp.mainWindow?.close()
				
			}
		}
	}
	
	@IBAction func likeButton_Click(sender: AnyObject) {
		indicator.startAnimation(self)
		let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
		dispatch_async(queue) {
			self.twitterClient.downloadFiles(TwitterClient.Target.Favorites, completion: self.completion)
		}
	}
	
	@IBAction func tweetButton_Click(sender: AnyObject) {
		indicator.startAnimation(self)
		let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
		dispatch_async(queue) {
			self.twitterClient.downloadFiles(TwitterClient.Target.Tweets, completion: self.completion)
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

