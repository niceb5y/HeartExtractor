//
//  HEXClient.Download.swift
//  HeartExtractor
//
//  Created by 김승호 on 2016. 8. 21..
//  Copyright © 2016년 Seungho Kim. All rights reserved.
//

import Foundation
import PromiseKit
import SwifterMac

extension HEXClient {
	class Download: NSObject {
		enum DownloadError: Error {
			case DownloadFailed, WriteFailed, FileExists
		}
		
		static func download(url:URL) -> Promise<URL>{
			return Promise { (fullfill, reject) in
				if (url.absoluteString.hasPrefix("http://pbs.twimg.com/media/")) {
					if (!HEXClient.History.includes(url: url)) {
						let originalURL = URL(string: url.absoluteString + ":orig")
						let fileName = originalURL?.absoluteString.replacingOccurrences( of: ":orig", with: "", options: NSString.CompareOptions.backwards, range: nil)
						let downloadsDirectoryURL = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first! as URL
						let destinationURL = downloadsDirectoryURL.appendingPathComponent(URL(string: fileName!)!.lastPathComponent)
						if (FileManager().fileExists(atPath: destinationURL.path)) {
							reject(DownloadError.FileExists)
						} else {
							if let data = try? Data(contentsOf: originalURL!) {
								if (try? data.write(to: destinationURL, options: [.atomic])) != nil {
									HEXClient.History.insert(url: url)
									fullfill(originalURL!)
								} else {
									reject(DownloadError.WriteFailed)
								}
							} else {
								reject(DownloadError.DownloadFailed)
							}
						}
					} else {
						fullfill(url)
					}
                } else if (url.absoluteString.hasPrefix("https://pbs.twimg.com/tweet_video/") ||
                    url.absoluteString.hasPrefix("https://video.twimg.com/")) {
                    if (!HEXClient.History.includes(url: url)) {
                        let fileName = url.absoluteString
                        let downloadsDirectoryURL = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first! as URL
                        let destinationURL = downloadsDirectoryURL.appendingPathComponent(URL(string: fileName)!.lastPathComponent)
                        if (FileManager().fileExists(atPath: destinationURL.path)) {
                            reject(DownloadError.FileExists)
                        } else {
                            if let data = try? Data(contentsOf: url) {
                                if (try? data.write(to: destinationURL, options: [.atomic])) != nil {
                                    HEXClient.History.insert(url: url)
                                    fullfill(url)
                                } else {
                                    reject(DownloadError.WriteFailed)
                                }
                            } else {
                                reject(DownloadError.DownloadFailed)
                            }
                        }
                    } else {
                        fullfill(url)
                    }
                }
			}
		}
	}
}
