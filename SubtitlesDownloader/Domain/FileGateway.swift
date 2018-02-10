//
//  FileGateway.swift
//  SubtitlesDownloader
//
//  Created by Sebastian Osiński on 23/01/2017.
//  Copyright © 2017 Sebastian Osiński. All rights reserved.
//

import Foundation
import RxSwift

enum FileError: Error {
    case unknown
}

protocol FileGateway {
    func contentsOfDirectory(path: String) -> Single<Result<[File], FileError>>
    func contents(path: String, offset: Int64, length: Int) -> Single<Result<Data, FileError>>
}
