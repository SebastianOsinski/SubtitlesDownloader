//
//  ComputeHashUseCase.swift
//  SubtitlesDownloader
//
//  Created by Sebastian Osiński on 28/01/2017.
//  Copyright © 2017 Sebastian Osiński. All rights reserved.
//

import RxSwift

class ComputeHashUseCase {

    private let file: File
    private let calculator: HashCalculator

    init(file: File, fileGateway: FileGateway) {
        self.file = file
        self.calculator = HashCalculator(fileGateway: fileGateway)
    }

    func execute() -> Single<Result<MovieHash, FileError>> {
        return Single.create { [calculator, file] observer in
            calculator.calculateHash(of: file) { result in
                observer(.success(result))
            }

            return Disposables.create()
        }
    }
}
