//
//  DummyFileGateway.swift
//  SubtitlesDownloader
//
//  Created by Sebastian Osiński on 26/01/2017.
//  Copyright © 2017 Sebastian Osiński. All rights reserved.
//

import Foundation
@testable import SubtitlesDownloader

class DummyFileGateway: FileGateway {

    func contentsOfDirectory(path: String, completion: @escaping (Result<[File]>) -> Void) -> OperationHandle? {
        return nil
    }

    func contents(path: String, offset: Int64, length: Int, completion: @escaping (Result<Data>) -> Void) -> OperationHandle? {
        return nil
    }
}
