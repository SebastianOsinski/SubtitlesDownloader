//
//  ShowFilesListUseCase.swift
//  SubtitlesDownloader
//
//  Created by Sebastian Osiński on 24/01/2017.
//  Copyright © 2017 Sebastian Osiński. All rights reserved.
//

import Foundation

typealias ShowFilesListCompletion = (Result<[File]>) -> Void

class ShowFilesListUseCase: UseCase {

    private let directoryPath: String
    private let gateway: FileGateway
    private let completion: ShowFilesListCompletion

    init(directoryPath: String, gateway: FileGateway, completion: @escaping ShowFilesListCompletion) {
        self.directoryPath = directoryPath
        self.gateway = gateway
        self.completion = completion
    }

    func execute() -> UseCaseHandle? {
        return gateway
            .contentsOfDirectory(path: directoryPath, completion: completion)
            .map(OperationHandleUseCaseHandleAdapter.init)
    }
}
