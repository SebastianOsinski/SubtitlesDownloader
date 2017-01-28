//
//  ComputeHashUseCase.swift
//  SubtitlesDownloader
//
//  Created by Sebastian Osiński on 28/01/2017.
//  Copyright © 2017 Sebastian Osiński. All rights reserved.
//

import Foundation

typealias HashingCompletion = (Result<String>) -> Void

class ComputeHashUseCase: UseCase {

    private let file: File
    private let calculator: HashCalculator
    private let completion: HashingCompletion

    init(file: File, fileGateway: FileGateway, completion: @escaping HashingCompletion) {
        self.file = file
        self.calculator = HashCalculator(fileGateway: fileGateway)
        self.completion = completion
    }

    func execute() -> UseCaseHandle? {
        calculator.calculateHash(of: file, completion: completion)
        return nil
    }
}
