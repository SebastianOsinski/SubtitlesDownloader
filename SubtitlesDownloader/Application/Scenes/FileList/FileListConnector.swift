//
//  FileListConnector.swift
//  SubtitlesDownloader
//
//  Created by Sebastian Osiński on 23/01/2017.
//  Copyright © 2017 Sebastian Osiński. All rights reserved.
//

import UIKit

class FileListConnector {

    private let path: String
    private let fileGateway: FileGateway

    private let navigationController: UINavigationController

    init(path: String, fileGateway: FileGateway, navigationController: UINavigationController) {
        self.path = path
        self.fileGateway = fileGateway
        self.navigationController = navigationController
    }

    func fileListViewController() -> UIViewController {
        let useCaseFactory = UseCaseFactory(fileGateway: fileGateway)
        let viewModel = FileListViewModel(path: path, useCaseFactory: useCaseFactory, connector: self)
        let viewController = FileListViewController(viewModel: viewModel)

        return viewController
    }

    func navigateToDirectory(atPath path: String) {
        let connector = FileListConnector(
            path: path,
            fileGateway: fileGateway,
            navigationController: navigationController
        )

        let viewController = connector.fileListViewController()

        navigationController.pushViewController(viewController, animated: true)
    }

    func showHashAlert(hash: String) {
        let alertController = UIAlertController(title: "Hash", message: hash, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        navigationController.present(alertController, animated: true, completion: nil)
    }
}
