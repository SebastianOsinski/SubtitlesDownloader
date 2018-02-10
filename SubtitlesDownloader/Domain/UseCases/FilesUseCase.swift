//
//  FilesUseCase.swift
//  SubtitlesDownloader
//
//  Created by Sebastian Osiński on 10.02.2018.
//  Copyright © 2018 Sebastian Osiński. All rights reserved.
//

import Foundation
import RxSwift

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
