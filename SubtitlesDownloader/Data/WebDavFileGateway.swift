//
//  WebDavFileGateway.swift
//  SubtitlesDownloader
//
//  Created by Sebastian Osiński on 26/01/2017.
//  Copyright © 2017 Sebastian Osiński. All rights reserved.
//

import Foundation
import FilesProvider

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

    func contentsOfDirectory(path: String, completion: @escaping (Result<[File]>) -> Void) -> OperationHandle? {
        monitor.increment()
        provider.contentsOfDirectory(path: path) { [unowned completionQueue, unowned monitor] (fileObjects, error) in
            guard error == nil else {
                completionQueue.async {
                    monitor.decrement()
                    completion(.failure(error!))
                }
                return
            }

            let files = FileObjectsMapper.files(from: fileObjects)

            completionQueue.async {
                monitor.decrement()
                completion(.success(files))
            }
        }

        return nil
    }

    func contents(path: String, offset: Int64, length: Int, completion: @escaping (Result<Data>) -> Void) -> OperationHandle? {
        monitor.increment()
        _ = provider.contents(path: path, offset: offset, length: length - 1) { [unowned completionQueue, unowned monitor] (data, error) in
            guard error == nil else {
                completionQueue.async {
                    monitor.decrement()
                    completion(.failure(error!))
                }
                return
            }

            completionQueue.async {
                monitor.decrement()
                completion(.success(data!))
            }
        }

        return nil
    }
}
