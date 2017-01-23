//
//  FileGateway.swift
//  SubtitlesDownloader
//
//  Created by Sebastian Osiński on 23/01/2017.
//  Copyright © 2017 Sebastian Osiński. All rights reserved.
//

import Foundation

protocol FileGateway {
    func contentsOfDirectory(path: String, completion: ResultCallback<[FileEntity]>) -> OperationHandle?
    func contents(path: String, offset: Int64, length: Int, completion: ResultCallback<Data>) -> OperationHandle?
}
