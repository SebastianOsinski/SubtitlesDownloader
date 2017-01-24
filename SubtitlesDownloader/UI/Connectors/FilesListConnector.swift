//
//  FilesListConnector.swift
//  SubtitlesDownloader
//
//  Created by Sebastian Osiński on 23/01/2017.
//  Copyright © 2017 Sebastian Osiński. All rights reserved.
//

import UIKit

class FilesListConnector {

    private let path: String
    private let fileGateway: FileGateway

    init(path: String, fileGateway: FileGateway) {
        self.path = path
        self.fileGateway = fileGateway
    }

    func filesListViewController() -> UIViewController {
        let useCaseFactory = UseCaseFactory(fileGateway: fileGateway)
        let presenter = FilesListPresenter(path: path, useCaseFactory: useCaseFactory)
        let viewController = FilesListViewController(presenter: presenter, connector: self)
        presenter.view = viewController

        return viewController
    }
}
