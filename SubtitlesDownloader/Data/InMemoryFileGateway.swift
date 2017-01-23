//
//  InMemoryFileGateway.swift
//  SubtitlesDownloader
//
//  Created by Sebastian Osiński on 23/01/2017.
//  Copyright © 2017 Sebastian Osiński. All rights reserved.
//

import Foundation

class InMemoryFileGateway: FileGateway {

    func contentsOfDirectory(path: String, completion: (Result<[File]>) -> Void) -> OperationHandle? {
        return nil
    }

    func contents(path: String, offset: Int64, length: Int, completion: (Result<Data>) -> Void) -> OperationHandle? {
        return nil
    }
}
