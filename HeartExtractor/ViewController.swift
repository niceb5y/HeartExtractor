//
//  ViewController.swift
//  HeartExtractor
//
//  Created by 김승호 on 2016. 4. 7..
//  Copyright © 2016 Seungho Kim. All rights reserved.
//

import Cocoa
import PromiseKit

class ViewController: NSViewController {
	@IBOutlet var textView: NSTextView!
	@IBOutlet weak var scrollView: NSScrollView!
	@IBOutlet weak var indicator: NSProgressIndicator!
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	@IBAction func likeButton_Click(_ sender: AnyObject) {
		indicator.startAnimation(self)
		HEXClient.Auth.getToken().then { (token) in
			return HEXClient.Fetch.fetchLimit(token: token)
		}.then { (limits, token) in
			return HEXClient.Fetch.fetchURL(target: HEXClient.Target.favorites, token: token, limits: limits, maxID: nil)
		}.then { (urls) -> Void in
			let downloads = urls.map({ url in
				return HEXClient.Download.download(url: url).catch { (error) in
				debugPrint(error)
				}
			})
			when(fulfilled: downloads).then { _ -> Void in
				let alert = NSAlert()
				alert.addButton(withTitle: NSLocalizedString("OK", comment: "OK"))
				alert.addButton(withTitle: NSLocalizedString("Quit", comment: "Quit"))
				alert.messageText = "Heart Extractor"
				alert.informativeText = NSLocalizedString("TaskComplete", comment: "TaskComplete")
				alert.alertStyle = NSAlertStyle.informational
				let response = alert.runModal()
				if response == NSAlertSecondButtonReturn {
					NSApp.mainWindow?.close()
				}
			}.always {
				self.indicator.stopAnimation(self)
			}.catch { (error) in
				debugPrint(error)
			}
		}.catch { (error) in
			debugPrint(error)
		}
	}
	
	@IBAction func tweetButton_Click(_ sender: AnyObject) {
		indicator.startAnimation(self)
		HEXClient.Auth.getToken().then { (token) in
			return HEXClient.Fetch.fetchLimit(token: token)
			}.then { (limits, token) in
				return HEXClient.Fetch.fetchURL(target: HEXClient.Target.tweets, token: token, limits: limits, maxID: nil)
			}.then { (urls) -> Void in
				let downloads = urls.map({ url in
					return HEXClient.Download.download(url: url).catch { (error) in
						debugPrint(error)
					}
				})
				when(fulfilled: downloads).then { _ -> Void in
					let alert = NSAlert()
					alert.addButton(withTitle: NSLocalizedString("OK", comment: "OK"))
					alert.addButton(withTitle: NSLocalizedString("Quit", comment: "Quit"))
					alert.messageText = "Heart Extractor"
					alert.informativeText = NSLocalizedString("TaskComplete", comment: "TaskComplete")
					alert.alertStyle = NSAlertStyle.informational
					let response = alert.runModal()
					if response == NSAlertSecondButtonReturn {
						NSApp.mainWindow?.close()
					}
				}.always {
					self.indicator.stopAnimation(self)
				}.catch { (error) in
						debugPrint(error)
				}
			}.catch { (error) in
				debugPrint(error)
		}

	}
	
	@IBAction func clearSession(_ sender: AnyObject) {
		HEXClient.Auth.clearToken()
		HEXClient.History.deleteAll()
		HEXClient.Auth.getToken().catch { (error) in
			debugPrint(error)
		}
	}	
}

