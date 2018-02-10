//
//  UseCaseFactory.swift
//  SubtitlesDownloader
//
//  Created by Sebastian Osiński on 24/01/2017.
//  Copyright © 2017 Sebastian Osiński. All rights reserved.
//

import Foundation
import RxSwift

class UseCaseFactory {

    enum Use {
        case showFiles(directoryPath: String, completion: ShowFilesListCompletion)
        case computeHash(file: File, completion: HashingCompletion)
    }

    private let fileGateway: FileGateway

    init(fileGateway: FileGateway) {
        self.fileGateway = fileGateway
    }

    func createUseCase(for use: Use) -> UseCase {
        switch use {
            case .showFiles(let directoryPath, let completion):
                return ShowFilesListUseCase(directoryPath: directoryPath, gateway: fileGateway, completion: completion)
            case .computeHash(let file, let completion):
                return ComputeHashUseCase(file: file, fileGateway: fileGateway, completion: completion)
        }
    }

    func filesUseCase() -> FilesUseCase {
        return FilesUseCase(gateway: fileGateway)
    }
}

class FilesUseCase {

    private let gateway: FileGateway

    init(gateway: FileGateway) {
        self.gateway = gateway
    }

    func files(at path: String) -> Single<Result<[File]>> {
        return Single.create { [gateway] observer -> Disposable in
            _ = gateway.contentsOfDirectory(path: path) { result in
                observer(.success(result))
            }

            return Disposables.create()
        }
    }

    func hash(file: File) -> Single<Result<MovieHash>> {
        return Single.create { [gateway] observer -> Disposable in
            _ = ComputeHashUseCase(file: file, fileGateway: gateway) { result in
                observer(.success(result))
            }

            return Disposables.create()
        }
    }
}
