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
