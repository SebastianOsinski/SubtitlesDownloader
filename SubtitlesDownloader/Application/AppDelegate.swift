//
//  AppDelegate.swift
//  SubtitlesDownloader
//
//  Created by Sebastian Osiński on 22/01/2017.
//  Copyright © 2017 Sebastian Osiński. All rights reserved.
//

import UIKit
import Swinject

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    private var rootConnector: MainConnector!

    private var gateway: SubtitlesGateway!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        rootConnector = MainConnector()
        rootConnector.connect()
        configureWindow(with: rootConnector.controller)

        return true
    }

    private func configureWindow(with viewController: UIViewController) {
        window = UIWindow(frame: UIScreen.main.bounds)
        window!.rootViewController = viewController
        window!.makeKeyAndVisible()
    }

    private func createContainer() -> Container {
        return Container { container in
            container
                .register(NetworkTasksMonitor.self, factory: { _ in UINetworkTasksMonitor() })
                .inObjectScope(.container)

            
        }
    }
}

final class RootConnector {

}

final class LoginConnector {

}

final class SettingsConnector {

}
