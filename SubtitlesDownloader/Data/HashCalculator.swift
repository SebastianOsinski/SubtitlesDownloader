//
//  HashCalculator.swift
//  SubtitlesDownloader
//
//  Created by Sebastian Osiński on 26/01/2017.
//  Copyright © 2017 Sebastian Osiński. All rights reserved.
//

import Foundation

class HashCalculator {

    private let fileGateway: FileGateway
    private let queue: OperationQueue

    init(fileGateway: FileGateway) {
        self.fileGateway = fileGateway
        self.queue = OperationQueue()
        queue.maxConcurrentOperationCount = 2
    }

    func calculateHash(of file: File, completion: ResultCallback<String>) {

    }
}
