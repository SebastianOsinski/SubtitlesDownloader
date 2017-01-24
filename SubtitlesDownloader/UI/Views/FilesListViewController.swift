//
//  FilesListViewController.swift
//  SubtitlesDownloader
//
//  Created by Sebastian Osiński on 23/01/2017.
//  Copyright © 2017 Sebastian Osiński. All rights reserved.
//

import UIKit

protocol FilesListViewProtocol: class {
    func refresh()
}

class FilesListViewController: UITableViewController {

    let presenter: FilesListPresenter
    let connector: FilesListConnector

    init(presenter: FilesListPresenter, connector: FilesListConnector) {
        self.presenter = presenter
        self.connector = connector
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        presenter.viewReady()
    }

    private func setupTableView() {
        tableView.register(FileTableViewCell.self)
        tableView.estimatedRowHeight = 40.0
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfFiles
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: FileTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        presenter.configureCell(cell, at: indexPath.row)

        return cell
    }
}


extension FilesListViewController: FilesListViewProtocol {

    func refresh() {
        tableView.reloadData()
    }
}
