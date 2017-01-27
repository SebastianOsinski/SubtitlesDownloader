//
//  HashCalculator.swift
//  SubtitlesDownloader
//
//  Created by Sebastian Osiński on 26/01/2017.
//  Copyright © 2017 Sebastian Osiński. All rights reserved.
//

import Foundation

class HashCalculator {

    private static let chunkLength = 65536

    private let fileGateway: FileGateway
    private let queue: OperationQueue

    init(fileGateway: FileGateway) {
        self.fileGateway = fileGateway
        self.queue = OperationQueue()
        queue.maxConcurrentOperationCount = 2
    }

    func calculateHash(of file: File, completion: @escaping ResultCallback<String>) {
        let size = file.size
        let path = file.path

        let startBytes = GetBytesOperation(
            path: path,
            offset: 0,
            length: HashCalculator.chunkLength,
            fileGateway: fileGateway
        )

        let offset = max(0, size - Int64(HashCalculator.chunkLength))

        let endBytes = GetBytesOperation(
            path: path,
            offset: offset,
            length: HashCalculator.chunkLength,
            fileGateway: fileGateway
        )

        let hashingOperation = HashingOperation(
            size: size,
            startBytes: startBytes,
            endBytes: endBytes
        )

        hashingOperation.completionBlock = { [unowned hashingOperation] in
            let result = hashingOperation.result!
            DispatchQueue.main.async {
                completion(result)
            }
        }

        queue.addOperations([startBytes, endBytes, hashingOperation], waitUntilFinished: false)
    }
}
