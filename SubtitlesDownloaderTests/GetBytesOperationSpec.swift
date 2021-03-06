//
//  GetBytesOperationSpec.swift
//  SubtitlesDownloader
//
//  Created by Sebastian Osiński on 27/01/2017.
//  Copyright © 2017 Sebastian Osiński. All rights reserved.
//

import Quick
import Nimble
import RxSwift
@testable import SubtitlesDownloader

class GetBytesOperationSpec: QuickSpec {

    override func spec() {

        describe("GetBytesOperation") {
            it("gets correct bytes") {
                let data = Data(bytes: [1, 2, 3, 4, 5, 6, 7])
                let gateway = MockFileGateway(data: data)

                let sut = GetBytesOperation(path: "", offset: 1, length: 3, fileGateway: gateway)
                sut.start()

                expect(sut.result.success).toEventually(equal(Data(bytes: [2, 3, 4])))
            }
        }
    }
}

private class MockFileGateway: FileGateway {

    private let data: Data

    init(data: Data) {
        self.data = data
    }

    func contentsOfDirectory(path: String) -> Single<Result<[File], FileError>> {
        return Single.just(.success([]))
    }
    func contents(path: String, offset: Int64, length: Int) -> Single<Result<Data, FileError>> {
        let slice = data[Int(offset)..<(Int(offset) + length)]
        return Single.just(.success(Data(slice)))
    }
}
