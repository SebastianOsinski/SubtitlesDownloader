//
//  FilesListViewController.swift
//  SubtitlesDownloader
//
//  Created by Sebastian Osiński on 23/01/2017.
//  Copyright © 2017 Sebastian Osiński. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension SharedSequenceConvertibleType {
    func mapToVoid() -> SharedSequence<SharingStrategy, Void> {
        return map { _ in }
    }
}

extension ObservableType {

    func catchErrorJustComplete() -> Observable<E> {
        return catchError { _ in
            return Observable.empty()
        }
    }

    func asDriverOnErrorJustComplete() -> Driver<E> {
        return asDriver { error in
            return Driver.empty()
        }
    }

    func mapToVoid() -> Observable<Void> {
        return map { _ in }
    }
}

protocol FilesListViewProtocol: class {
    func refresh()
    func reportError(_ error: String)
}

class FilesListViewController: UIViewController {

    private let tableView = UITableView()

    let presenter: FilesListPresenter
    let disposeBag = DisposeBag()

    init(presenter: FilesListPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        bind()
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

    private func bind() {
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
            .mapToVoid()
            .asDriverOnErrorJustComplete()
        let pull = tableView.refreshControl!.rx
            .controlEvent(.valueChanged)
            .asDriver()


        let selection = tableView.rx.itemSelected.asDriver()

        let input = FilesListPresenter.Input(
            trigger: Driver.merge(viewWillAppear, pull),
            selection: selection
        )

        let output = presenter.transform(input: input)

        output.files
            .drive(tableView.rx.items(cellIdentifier: FileTableViewCell.defaultReuseIdentifier, cellType: FileTableViewCell.self)) { _, viewModel, cell in
                cell.bind(viewModel)
            }
            .disposed(by: disposeBag)
    }
}


extension FilesListViewController: FilesListViewProtocol {

    func refresh() {
        tableView.reloadData()
    }

    func reportError(_ error: String) {
        let alertController = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}
