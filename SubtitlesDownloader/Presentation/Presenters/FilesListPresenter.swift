//
//  FilesListPresenter.swift
//  SubtitlesDownloader
//
//  Created by Sebastian Osiński on 23/01/2017.
//  Copyright © 2017 Sebastian Osiński. All rights reserved.
//

import Foundation

class FilesListPresenter {

    weak var view: FilesListViewProtocol?

    private let connector: FilesListConnector

    private let path: String
    private let useCaseFactory: UseCaseFactory

    private var files = [File]()

    init(path: String, useCaseFactory: UseCaseFactory, connector: FilesListConnector) {
        self.path = path
        self.useCaseFactory = useCaseFactory
        self.connector = connector
    }

    var numberOfFiles: Int {
        return files.count
    }
    
    func viewReady() {
        let useCase = createShowFilesListUseCase()
        useCase.execute()
    }

    func configureCell(_ cell: FileCellProtocol, at index: Int) {
        cell.displayName(files[index].name)
    }

    func cellSelected(at index: Int) {
        let file = files[index]

        switch file.type {
        case .regular:
            let useCase = createComputeHashUseCase(file: file)
            useCase.execute()
        case .directory:
            connector.navigateToDirectory(atPath: file.path)
        }
    }

    private func createShowFilesListUseCase() -> UseCase {
        return useCaseFactory.createUseCase(for: .showFiles(directoryPath: path) { [weak self] result in
            switch result {
            case .success(let files):
                self?.files = files
                self?.view?.refresh()
            case .failure(let error):
                print(error)
            }
        })
    }

    private func createComputeHashUseCase(file: File) -> UseCase {
        return useCaseFactory.createUseCase(for: .computeHash(file: file) { [weak connector] result in
            connector?.showHashAlert(hash: result.success ?? "error")
        })
    }
}
