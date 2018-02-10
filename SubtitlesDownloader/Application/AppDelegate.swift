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

    private var rootConnector: FileListConnector!

    private var gateway: SubtitlesGateway!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let monitor = UINetworkTasksMonitor()

        gateway = OpenSubtitlesGateway(
            apiClient: XmlRpcApiClient(url: URL(string: "http://api.opensubtitles.org/xml-rpc")!, monitor: monitor)
        )


        //let fileGateway = LocalFileGateway()
        let fileGateway = WebDavFileGateway(baseUrl: URL(string: "http://localhost:1111")!, user: "user", password: "password", monitor: UINetworkTasksMonitor())
        let navigationController = UINavigationController()
        rootConnector = FileListConnector(
            path: "",
            fileGateway: fileGateway,
            navigationController: navigationController
        )

        navigationController.pushViewController(rootConnector.fileListViewController(), animated: false)
        configureWindow(with: navigationController)

        return true
    }

    private func configureWindow(with viewController: UIViewController) {
        window = UIWindow(frame: UIScreen.main.bounds)
        window!.rootViewController = viewController
        window!.makeKeyAndVisible()
    }
}
