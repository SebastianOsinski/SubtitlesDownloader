//
//  AppDelegate.swift
//  SubtitlesDownloader
//
//  Created by Sebastian Osiński on 22/01/2017.
//  Copyright © 2017 Sebastian Osinski. All rights reserved.
//

import UIKit
import FileProvider

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    private var webDavProvider: WebDAVFileProvider!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        return true
    }
}

