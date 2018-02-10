//
//  FileListViewController.swift
//  SubtitlesDownloader
//
//  Created by Sebastian Osiński on 23/01/2017.
//  Copyright © 2017 Sebastian Osiński. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol FilesListViewProtocol: class {
    func refresh()
    func reportError(_ error: String)
}

class FileListViewController: UIViewController {

    private let tableView = UITableView()

    private let viewModel: FileListViewModel

    private let disposeBag = DisposeBag()

    init(viewModel: FileListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        bindViewModel()
    }

    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        tableView.register(FileTableViewCell.self)
        tableView.estimatedRowHeight = 40.0
        tableView.rowHeight = UITableViewAutomaticDimension

        tableView.refreshControl = UIRefreshControl()
    }

    private func bindViewModel() {
        let selection = tableView.rx.itemSelected.asDriver()

        let input = FileListViewModel.Input(
            trigger: refreshTrigger(),
            selection: selection
        )

        let output = viewModel.transform(input: input)

        output.data
            .drive(tableView.rx.items(cellType: FileTableViewCell.self)) { _, viewModel, cell in
                cell.bind(viewModel)
            }
            .disposed(by: disposeBag)

        output.fetching
            .drive(tableView.refreshControl!.rx.isRefreshing)
            .disposed(by: disposeBag)
    }

    private func refreshTrigger() -> Driver<Void> {
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear))
            .mapToVoid()
            .asDriverOnErrorJustComplete()

        let pull = tableView.refreshControl!.rx
            .controlEvent(.valueChanged)
            .asDriver()

        return Driver.merge(viewWillAppear, pull)
    }

}
