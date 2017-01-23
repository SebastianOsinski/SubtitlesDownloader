//
//  FilesListConnector.swift
//  SubtitlesDownloader
//
//  Created by Sebastian Osiński on 23/01/2017.
//  Copyright © 2017 Sebastian Osiński. All rights reserved.
//

import UIKit

class FilesListConnector {

    private let fileGateway: FileGateway

    init(fileGateway: FileGateway) {
        self.fileGateway = fileGateway
    }

    func filesListViewController() -> UIViewController {
        let presenter = FilesListPresenter()
        let viewController = FilesListViewController(presenter: presenter, connector: self)

        return viewController
    }
}
