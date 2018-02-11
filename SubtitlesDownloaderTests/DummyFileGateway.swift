//
//  DummyFileGateway.swift
//  SubtitlesDownloader
//
//  Created by Sebastian Osiński on 26/01/2017.
//  Copyright © 2017 Sebastian Osiński. All rights reserved.
//

import Foundation
import RxSwift
@testable import SubtitlesDownloader

class DummyFileGateway: FileGateway {

    func contentsOfDirectory(path: String) -> Single<Result<[File], FileError>> {
        return Single.just(.success([]))
    }

    func contents(path: String, offset: Int64, length: Int) -> Single<Result<Data, FileError>> {
        return Single.just(.success(Data()))
    }
}
