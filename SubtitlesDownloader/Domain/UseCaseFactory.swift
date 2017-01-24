//
//  UseCaseFactory.swift
//  SubtitlesDownloader
//
//  Created by Sebastian Osiński on 24/01/2017.
//  Copyright © 2017 Sebastian Osiński. All rights reserved.
//

import Foundation

class UseCaseFactory {

    enum Use {
        case showFiles(directoryPath: String, completion: ShowFilesListCompletion)
    }

    private let fileGateway: FileGateway

    init(fileGateway: FileGateway) {
        self.fileGateway = fileGateway
    }

    func createUseCase(for use: Use) -> UseCase {
        switch use {
            case .showFiles(let directoryPath, let completion):
                return ShowFilesListUseCase(directoryPath: directoryPath, gateway: fileGateway, completion: completion)
        }
    }
}
