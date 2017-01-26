//
//  HashCalculatorSpec.swift
//  SubtitlesDownloader
//
//  Created by Sebastian Osiński on 26/01/2017.
//  Copyright © 2017 Sebastian Osiński. All rights reserved.
//

import Quick
import Nimble
@testable import SubtitlesDownloader

class HashCalculatorSpec: QuickSpec {

    override func spec() {

        describe("HashCalculator") {
            var calculator: HashCalculator!

            beforeEach {
                calculator = HashCalculator(fileGateway: TestFileGateway())
            }

            it("calculates hash for test avi file") {
                let path = Bundle(for: HashCalculatorSpec.self).path(forResource: "breakdance", ofType: "avi")!
                let fileSize = FileHandle(forReadingAtPath: path)!.seekToEndOfFile()
                let file = File(name: "test", path: path, type: .regular, size: Int64(fileSize))

                var hash = ""

                calculator.calculateHash(of: file) { result in
                    if case .success(let hashString) = result {
                        hash = hashString
                    }
                }

                expect(hash).toEventually(equal("8e245d9679d31e12"))
            }

            it("calculates hash for test rar file") {
                let path = Bundle(for: HashCalculatorSpec.self).path(forResource: "dummy", ofType: "rar")!
                let fileSize = FileHandle(forReadingAtPath: path)!.seekToEndOfFile()
                let file = File(name: "test", path: path, type: .regular, size: Int64(fileSize))

                var hash = ""

                calculator.calculateHash(of: file) { result in
                    if case .success(let hashString) = result {
                        hash = hashString
                    }
                }

                expect(OpenSubtitlesHash.hashFor(path).fileHash).to(equal("61f7751fc2a72bfb"))
                expect(hash).toEventually(equal("61f7751fc2a72bfb"))
            }
        }

    }
}

class OpenSubtitlesHash: NSObject {
    static let chunkSize: Int = 65536

    struct VideoHash {
        var fileHash: String
        var fileSize: UInt64
    }

    public class func hashFor(_ url: URL) -> VideoHash {
        return self.hashFor(url.path)
    }

    public class func hashFor(_ path: String) -> VideoHash {
        var fileHash = VideoHash(fileHash: "", fileSize: 0)
        let fileHandler = FileHandle(forReadingAtPath: path)!

        let fileDataBegin: NSData = fileHandler.readData(ofLength: chunkSize) as NSData
        fileHandler.seekToEndOfFile()

        let fileSize: UInt64 = fileHandler.offsetInFile
        if (UInt64(chunkSize) > fileSize) {
            return fileHash
        }

        fileHandler.seek(toFileOffset: max(0, fileSize - UInt64(chunkSize)))
        let fileDataEnd: NSData = fileHandler.readData(ofLength: chunkSize) as NSData

        var hash: UInt64 = fileSize

        var data_bytes = UnsafeBufferPointer<UInt64>(
            start: UnsafePointer(fileDataBegin.bytes.assumingMemoryBound(to: UInt64.self)),
            count: fileDataBegin.length/MemoryLayout<UInt64>.size
        )

        hash = data_bytes.reduce(hash,&+)

        data_bytes = UnsafeBufferPointer<UInt64>(
            start: UnsafePointer(fileDataEnd.bytes.assumingMemoryBound(to: UInt64.self)),
            count: fileDataEnd.length/MemoryLayout<UInt64>.size
        )

        hash = data_bytes.reduce(hash,&+)

        fileHash.fileHash = String(format:"%016qx", arguments: [hash])
        fileHash.fileSize = fileSize

        fileHandler.closeFile()

        return fileHash
    }
}


private class TestFileGateway: FileGateway {

    func contentsOfDirectory(path: String, completion: @escaping (Result<[File]>) -> Void) -> OperationHandle? {
        return nil
    }

    func contents(path: String, offset: Int64, length: Int, completion: @escaping (Result<Data>) -> Void) -> OperationHandle? {

        let fileHandle = FileHandle(forReadingAtPath: path)!

        fileHandle.seek(toFileOffset: UInt64(offset))
        let data = fileHandle.readData(ofLength: length)

        completion(.success(data))

        fileHandle.closeFile()
        return nil
    }
}
