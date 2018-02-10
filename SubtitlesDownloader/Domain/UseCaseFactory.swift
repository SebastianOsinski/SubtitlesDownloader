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

    private let fileGateway: FileGateway

    init(fileGateway: FileGateway) {
        self.fileGateway = fileGateway
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

    func files(at path: String) -> Single<Result<[File], FileError>> {
        return gateway.contentsOfDirectory(path: path)
    }

    func hash(file: File) -> Single<Result<MovieHash, FileError>> {
        return ComputeHashUseCase(file: file, fileGateway: gateway).execute()
    }
}
