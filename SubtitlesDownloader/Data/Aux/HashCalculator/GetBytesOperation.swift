//
//  GetBytesOperation.swift
//  SubtitlesDownloader
//
//  Created by Sebastian Osiński on 26/01/2017.
//  Copyright © 2017 Sebastian Osiński. All rights reserved.
//

import Foundation
import RxSwift

class GetBytesOperation: AsyncOperation {

    private let path: String
    private let offset: Int64
    private let length: Int
    private let fileGateway: FileGateway

    private var disposable: Disposable?

    private(set) var result: Result<Data, FileError>!

    init(path: String, offset: Int64, length: Int, fileGateway: FileGateway) {
        self.path = path
        self.offset = offset
        self.length = length
        self.fileGateway = fileGateway
    }

    override func main() {
        disposable = fileGateway.contents(path: path, offset: offset, length: length)
            .subscribe(onSuccess: { [weak self] result in
                if self?.isCancelled ?? true {
                    return
                }
                print(result)
                self?.result = result
                self?.state = .finished
            })
    }

    override func cancel() {
        super.cancel()
        disposable?.dispose()
    }
}
