//
//  FileListViewModel.swift
//  SubtitlesDownloader
//
//  Created by Sebastian Osiński on 23/01/2017.
//  Copyright © 2017 Sebastian Osiński. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxSwiftExt

class FileListViewModel {

    struct Input {
        let trigger: Driver<Void>
        let selection: Driver<IndexPath>
    }

    struct Output {
        let fetching: Driver<Bool>
        let data: Driver<[FileCellViewModel]>
    }
    
    private let connector: FileListConnector

    private let path: String
    private let useCase: FilesUseCase

    private var files = [File]()

    private var disposeBag = DisposeBag()

    init(path: String, useCaseFactory: UseCaseFactory, connector: FileListConnector) {
        self.path = path
        self.useCase = useCaseFactory.filesUseCase()
        self.connector = connector
    }

    func transform(input: Input) -> Output {
        disposeBag = DisposeBag()

        let activityIndicator = ActivityIndicator()

        let files = input.trigger.flatMapLatest { [useCase, path] in
            useCase.files(at: path)
                .asObservable()
                .trackActivity(activityIndicator)
                .asDriverOnErrorJustComplete()
        }

        let successes = files.successes()

        let fetching = activityIndicator.asDriver()
        let fileViewModels = successes.map { $0.map(FileCellViewModel.init) }

        let selectionDriver = input.selection
            .withLatestFrom(successes) { (indexPath, files) in
                return files[indexPath.row]
            }
            .do(onNext: { [connector] file in
                switch file.type {
                case .regular:
                    if file.path.hasSuffix("avi") {
                        connector.navigateToVideoFile(atPath: file.path)
                    } else {
                        connector.navigateToOtherFile(atPath: file.path)
                    }
                case .directory:
                    connector.navigateToDirectory(atPath: file.path)
                }
            })

        selectionDriver
            .drive()
            .disposed(by: disposeBag)

        return Output(fetching: fetching, data: fileViewModels)
    }
}
