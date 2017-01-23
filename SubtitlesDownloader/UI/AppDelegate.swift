//
//  AppDelegate.swift
//  SubtitlesDownloader
//
//  Created by Sebastian Osiński on 22/01/2017.
//  Copyright © 2017 Sebastian Osiński. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    private var rootConnector: FilesListConnector!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        let fileGateway = InMemoryFileGateway()
        rootConnector = FilesListConnector(fileGateway: fileGateway)

        let rootViewController = rootConnector.filesListViewController()
        configureWindow(with: rootViewController)

        return true
    }

    private func configureWindow(with viewController: UIViewController) {
        window = UIWindow(frame: UIScreen.main.bounds)
        window!.rootViewController = viewController
        window!.makeKeyAndVisible()
    }
}

