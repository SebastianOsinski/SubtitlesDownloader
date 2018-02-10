//
//  WebDavFileGateway.swift
//  SubtitlesDownloader
//
//  Created by Sebastian Osiński on 26/01/2017.
//  Copyright © 2017 Sebastian Osiński. All rights reserved.
//

import Foundation
import FilesProvider
import RxSwift

class WebDavFileGateway: FileGateway {

    private let provider: WebDAVFileProvider
    private let completionQueue: DispatchQueue = .main
    private let monitor: NetworkTasksMonitor

    init(baseUrl: URL, user: String, password: String, monitor: NetworkTasksMonitor) {
        self.provider = WebDAVFileProvider(
            baseURL: baseUrl,
            credential: URLCredential(user: user, password: password, persistence: .none)
        )!
        self.monitor = monitor
    }

    func contentsOfDirectory(path: String) -> Single<Result<[File], FileError>> {
        monitor.increment()

        return Single.create { [provider, monitor, completionQueue] observer in
            provider.contentsOfDirectory(path: path) { (fileObjects, error) in
                guard error == nil else {
                    completionQueue.async {
                        monitor.decrement()
                        observer(.success(.failure(.unknown)))
                    }
                    return
                }

                let files = FileObjectsMapper.files(from: fileObjects)

                completionQueue.async {
                    monitor.decrement()
                    observer(.success(.success(files)))
                }
            }

            return Disposables.create()
        }
    }

    func contents(path: String, offset: Int64, length: Int) -> Single<Result<Data, FileError>> {
        return Single.create { [provider, monitor, completionQueue] observer in
            _ = provider.contents(path: path, offset: offset, length: length - 1) { (data, error) in
                guard error == nil else {
                    completionQueue.async {
                        monitor.decrement()
                        observer(.success(.failure(.unknown)))
                    }
                    return
                }

                completionQueue.async {
                    monitor.decrement()
                    observer(.success(.success(data!)))
                }
            }

            return Disposables.create()
        }
    }
}
