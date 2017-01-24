//
//  FileGateway.swift
//  SubtitlesDownloader
//
//  Created by Sebastian Osiński on 23/01/2017.
//  Copyright © 2017 Sebastian Osiński. All rights reserved.
//

import Foundation

protocol FileGateway {
    func contentsOfDirectory(path: String, completion: @escaping ResultCallback<[File]>) -> OperationHandle?
    func contents(path: String, offset: Int64, length: Int, completion: @escaping ResultCallback<Data>) -> OperationHandle?
}
