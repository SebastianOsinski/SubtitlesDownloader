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
            endBytes: endBytes,
            completion: completion
        )

        queue.addOperations([startBytes, endBytes, hashingOperation], waitUntilFinished: false)
    }
}

class HashingOperation: AsyncOperation {

    private let size: Int64
    private let startBytes: GetBytesOperation
    private let endBytes: GetBytesOperation
    private let completion: ResultCallback<String>

    init(size: Int64, startBytes: GetBytesOperation, endBytes: GetBytesOperation, completion: @escaping ResultCallback<String>) {
        self.size = size
        self.startBytes = startBytes
        self.endBytes = endBytes
        self.completion = completion

        super.init()

        addDependency(startBytes)
        addDependency(endBytes)
    }

    override func main() {
        guard
            let startBytesResult = startBytes.result,
            let endBytesResult = endBytes.result
        else {
            return
        }

        let start: NSData
        let end: NSData

        switch (startBytesResult, endBytesResult) {
        case (.failure(let error), _), (_, .failure(let error)):
            completion(.failure(error))
            state = .finished
            return
        case (.success(let startData), .success(let endData)):
            start = startData as NSData
            end = endData as NSData
        default:
            fatalError("Unhandled case")
        }

        var hash = UInt64(size)

        var dataBytes = UnsafeBufferPointer<UInt64>(
            start: UnsafePointer(start.bytes.assumingMemoryBound(to: UInt64.self)),
            count: end.length / MemoryLayout<UInt64>.size
        )

        hash = dataBytes.reduce(hash,&+)

        dataBytes = UnsafeBufferPointer<UInt64>(
            start: UnsafePointer(end.bytes.assumingMemoryBound(to: UInt64.self)),
            count: end.length / MemoryLayout<UInt64>.size
        )

        hash = dataBytes.reduce(hash,&+)

        let hashString = String(format: "%016qx", arguments: [hash])

        completion(.success(hashString))
        state = .finished
    }
}
