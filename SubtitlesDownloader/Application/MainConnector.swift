//
//  MainConnector.swift
//  SubtitlesDownloader
//
//  Created by Sebastian Osiński on 13.02.2018.
//  Copyright © 2018 Sebastian Osiński. All rights reserved.
//

import UIKit

final class MainConnector: FileListConnector {

    var controller: UIViewController {
        return splitViewController
    }

    private let splitViewController = UISplitViewController()
    private let navigationController = UINavigationController()

    private var useCaseFactory: UseCaseFactory!

    func connect() {
        splitViewController.delegate = self

//        let monitor = UINetworkTasksMonitor()

//        let gateway = OpenSubtitlesGateway(
//            apiClient: XmlRpcApiClient(url: URL(string: "http://api.opensubtitles.org/xml-rpc")!, monitor: monitor)
//        )

        //let fileGateway = LocalFileGateway()
        let fileGateway = WebDavFileGateway(baseUrl: URL(string: "http://Sebastians-MacBook-Pro-15.local:1111/")!, user: "user", password: "password", monitor: UINetworkTasksMonitor())
        useCaseFactory = UseCaseFactory(fileGateway: fileGateway)

        splitViewController.viewControllers = [navigationController, PlaceholderViewController()]

        navigationController.pushViewController(fileListViewController(forPath: ""), animated: false)
    }

    func navigateToDirectory(atPath path: String) {
        let viewController = fileListViewController(forPath: path)
        navigationController.pushViewController(viewController, animated: true)
    }

    func navigateToVideoFile(atPath path: String) {
        let videoFileViewController = VideoFileViewController(nibName: nil, bundle: nil)
        showViewControllerDependingOnCollapsedState(videoFileViewController)
    }

    func navigateToOtherFile(atPath path: String) {
        let unsupportedFileViewController = UnsupportedFileViewController(nibName: nil, bundle: nil)
        showViewControllerDependingOnCollapsedState(unsupportedFileViewController)
    }

    private func fileListViewController(forPath path: String) -> UIViewController {
        let viewModel = FileListViewModel(path: path, useCaseFactory: useCaseFactory, connector: self)
        let viewController = FileListViewController(viewModel: viewModel)

        return viewController
    }

    private func showViewControllerDependingOnCollapsedState(_ viewController: UIViewController) {
        if splitViewController.isCollapsed {
            navigationController.pushViewController(viewController, animated: true)
        } else {
            splitViewController.showDetailViewController(viewController, sender: self)
        }
    }
}

extension MainConnector: UISplitViewControllerDelegate {

    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {

        return !(secondaryViewController is VideoFileViewController)

        //return true
    }

    func splitViewController(_ splitViewController: UISplitViewController, showDetail vc: UIViewController, sender: Any?) -> Bool {
        guard let sender = sender else {
            return true
        }
        return (sender as AnyObject) !== self
    }

    func splitViewController(_ splitViewController: UISplitViewController, separateSecondaryFrom primaryViewController: UIViewController) -> UIViewController? {
        if navigationController.topViewController! is FileListViewController {
            return PlaceholderViewController()
        } else {
            return nil
        }
    }
}

final class PlaceholderViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
    }
}

final class UnsupportedFileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
    }
}
