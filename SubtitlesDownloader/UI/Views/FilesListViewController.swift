//
//  FilesListViewController.swift
//  SubtitlesDownloader
//
//  Created by Sebastian Osiński on 23/01/2017.
//  Copyright © 2017 Sebastian Osiński. All rights reserved.
//

import UIKit

class FilesListViewController: UITableViewController {

    var presenter: FilesListPresenter!
    var connector: FilesListConnector!

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewReady()
    }
}
