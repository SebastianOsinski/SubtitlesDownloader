//
//  HashingOperation.swift
//  SubtitlesDownloader
//
//  Created by Sebastian Osiński on 27/01/2017.
//  Copyright © 2017 Sebastian Osiński. All rights reserved.
//

import Foundation

class HashingOperation: Operation {

    private let size: Int64
    private let startBytes: GetBytesOperation
    private let endBytes: GetBytesOperation

    private(set) var result: Result<String, FileError>!

    init(size: Int64, startBytes: GetBytesOperation, endBytes: GetBytesOperation) {
        self.size = size
        self.startBytes = startBytes
        self.endBytes = endBytes

        super.init()

        addDependency(startBytes)
        addDependency(endBytes)
    }

    override func main() {

        let start: NSData
        let end: NSData

        switch (startBytes.result!, endBytes.result!) {
        case (.failure(let error), _), (_, .failure(let error)):
            result = .failure(error)
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

        result = .success(String(format: "%016qx", arguments: [hash]))
    }
}
