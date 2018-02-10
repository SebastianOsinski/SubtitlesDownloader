//
//  FilesListPresenter.swift
//  SubtitlesDownloader
//
//  Created by Sebastian Osiński on 23/01/2017.
//  Copyright © 2017 Sebastian Osiński. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxSwiftExt

extension Observable where Element: ResultType {

    func successes() -> Observable<Element.SuccessType> {
        return self.map { $0.success }.unwrap()
    }
}

extension Driver where Element: ResultType {

    func successes() -> Driver<Element.SuccessType> {
        return self
            .map { $0.success }
            .filter { $0 != nil }
            .map { $0! }
            .asDriver { error in
                return Driver.empty()
            }
    }
}

struct FileCellViewModel {

    let name: String

    init(file: File) {
        self.name = file.name
    }
}

class FilesListPresenter {

    struct Input {
        let trigger: Driver<Void>
        let selection: Driver<IndexPath>
    }

    struct Output {
        //let fetching: Driver<Bool>
        let files: Driver<[FileCellViewModel]>
        //let driver: Driver<Void>
    }

    weak var view: FilesListViewProtocol?

    private let connector: FilesListConnector

    private let path: String
    private let useCase: FilesUseCase

    private var files = [File]()

    private var disposeBag = DisposeBag()

    init(path: String, useCaseFactory: UseCaseFactory, connector: FilesListConnector) {
        self.path = path
        self.useCase = useCaseFactory.filesUseCase()
        self.connector = connector
    }

    func transform(input: Input) -> Output {
        disposeBag = DisposeBag()

        let files = input.trigger.flatMapLatest { [unowned self] in
            self.useCase.files(at: self.path)
                .asDriver(onErrorJustReturn: .success([]))
        }

        let successes = files.successes()

        let fileViewModels = successes.map { $0.map(FileCellViewModel.init) }

        let selectionDriver = input.selection
            .withLatestFrom(successes) { (indexPath, files) in
                return files[indexPath.row]
            }
            .do(onNext: { [connector] file in
                switch file.type {
                case .regular:
                    break
                case .directory:
                    connector.navigateToDirectory(atPath: file.path)
                }
            })

        selectionDriver
            .drive()
            .disposed(by: disposeBag)

        return Output(files: fileViewModels)
    }
//
//    var numberOfFiles: Int {
//        return files.count
//    }
//
//    func viewReady() {
//        let useCase = createShowFilesListUseCase()
//        useCase.execute()
//    }
//
//    func configureCell(_ cell: FileCellProtocol, at index: Int) {
//        cell.displayName(files[index].name)
//    }

//    func cellSelected(at index: Int) {
//        let file = files[index]
//

//    }
//
//    private func createShowFilesListUseCase() -> UseCase {
//        return useCaseFactory.createUseCase(for: .showFiles(directoryPath: path) { [weak self] result in
//            switch result {
//            case .success(let files):
//                self?.files = files
//                self?.view?.refresh()
//            case .failure(let error):
//                self?.view?.reportError(error.localizedDescription)
//            }
//        })
//    }
//
//    private func createComputeHashUseCase(file: File) -> UseCase {
//        return useCaseFactory.createUseCase(for: .computeHash(file: file) { [weak self] result in
//            switch result {
//            case .success(let hash):
//                self?.connector.showHashAlert(hash: hash.hash)
//            case .failure(let error):
//                self?.view?.reportError(error.localizedDescription)
//            }
//        })
//    }
}
