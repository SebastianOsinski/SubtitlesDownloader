//
//  UseCase.swift
//  SubtitlesDownloader
//
//  Created by Sebastian Osiński on 24/01/2017.
//  Copyright © 2017 Sebastian Osiński. All rights reserved.
//

protocol UseCaseHandle: class {
    func cancel()
}

protocol UseCase: class {
    @discardableResult func execute() -> UseCaseHandle?
}

class OperationHandleUseCaseHandleAdapter: UseCaseHandle {

    private let handle: OperationHandle

    init(handle: OperationHandle) {
        self.handle = handle
    }

    func cancel() {
        handle.cancel()
    }
}
