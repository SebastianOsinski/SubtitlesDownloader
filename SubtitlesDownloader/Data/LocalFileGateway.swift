//
//  LocalFileGateway.swift
//  SubtitlesDownloader
//
//  Created by Sebastian Osiński on 23/01/2017.
//  Copyright © 2017 Sebastian Osiński. All rights reserved.
//

import Foundation
import FilesProvider
import RxSwift

class LocalFileGateway: FileGateway {

    private let provider: LocalFileProvider

    private let completionQueue: DispatchQueue = .main

    init() {
        let manager = FileManager.default
        let documents = manager.urls(for: .documentDirectory, in: .userDomainMask).first!

        let root = "SubtitlesDownloader"
        let rootUrl = documents.appendingPathComponent(root)

        try? manager.removeItem(at: rootUrl)

        manager.changeCurrentDirectoryPath(documents.path)
        try! manager.createDirectory(atPath: root, withIntermediateDirectories: false, attributes: nil)
        try! manager.createDirectory(atPath: "\(root)/Test A", withIntermediateDirectories: false, attributes: nil)
        try! manager.createDirectory(atPath: "\(root)/Test B", withIntermediateDirectories: false, attributes: nil)
        try! manager.createDirectory(atPath: "\(root)/Test C", withIntermediateDirectories: false, attributes: nil)

        if let breakdanceUrl = Bundle.main.url(forResource: "breakdance", withExtension: "avi") {
            try? manager.copyItem(at: breakdanceUrl, to: documents.appendingPathComponent("\(root)/Test A/breakdance.avi"))
        }

        self.provider = LocalFileProvider(baseURL: rootUrl)
    }

    func contentsOfDirectory(path: String) -> Single<Result<[File], FileError>> {
        return Single.create { [provider, completionQueue] observer in
            provider.contentsOfDirectory(path: path) { (fileObjects, error) in
                guard error == nil else {
                    completionQueue.async {
                        observer(.success(.failure(.unknown)))
                    }
                    return
                }

                let files = FileObjectsMapper.files(from: fileObjects)

                completionQueue.async {
                    observer(.success(.success(files)))
                }
            }

            return Disposables.create()
        }
    }

    func contents(path: String, offset: Int64, length: Int) -> Single<Result<Data, FileError>> {
        return Single.create { [provider, completionQueue] observer in
            provider.contents(path: path, offset: offset, length: length) { [unowned completionQueue] (data, error) in
                guard error == nil else {
                    completionQueue.async {
                        observer(.success(.failure(.unknown)))
                    }
                    return
                }

                completionQueue.async {
                    observer(.success(.success(data!)))
                }
            }
            
            return Disposables.create()
        }
    }
}
