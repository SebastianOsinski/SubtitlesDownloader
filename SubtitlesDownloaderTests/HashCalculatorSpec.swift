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

                expect(hash).toEventually(equal("8e245d9679d31e12"), timeout: 3)
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

                expect(hash).toEventually(equal("2a527d74d45f5b1b"), timeout: 3)
            }
        }

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
