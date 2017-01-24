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

    private let path: String
    private let useCaseFactory: UseCaseFactory

    private var files = [File]()

    init(path: String, useCaseFactory: UseCaseFactory) {
        self.path = path
        self.useCaseFactory = useCaseFactory
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

        if file.type == .directory {
            view?.showDirectory(atPath: file.path)
        }
    }

    func pathForDirectory(at index: Int) -> String {
        return files[index].path
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
}
