//
//  LocalFileGateway.swift
//  SubtitlesDownloader
//
//  Created by Sebastian Osiński on 23/01/2017.
//  Copyright © 2017 Sebastian Osiński. All rights reserved.
//

import Foundation
import FileProvider

class LocalFileGateway: FileGateway {

    private let provider: LocalFileProvider
    private let completionQueue: DispatchQueue = .main

    init() {
        let manager = FileManager.default

        let documents = manager.urls(for: .documentDirectory, in: .userDomainMask).first!

        let root = "SubtitlesDownloader"

        try? manager.removeItem(at: documents.appendingPathComponent(root))

        manager.changeCurrentDirectoryPath(documents.path)
        try! manager.createDirectory(atPath: root, withIntermediateDirectories: false, attributes: nil)
        try! manager.createDirectory(atPath: "\(root)/Test A", withIntermediateDirectories: false, attributes: nil)
        try! manager.createDirectory(atPath: "\(root)/Test B", withIntermediateDirectories: false, attributes: nil)
        try! manager.createDirectory(atPath: "\(root)/Test C", withIntermediateDirectories: false, attributes: nil)

        self.provider = LocalFileProvider(baseURL: documents.appendingPathComponent(root))
    }

    func contentsOfDirectory(path: String, completion: @escaping (Result<[File]>) -> Void) -> OperationHandle? {
        provider.contentsOfDirectory(path: path) { [unowned completionQueue] (fileObjects, error) in
            guard error == nil else {
                completionQueue.async {
                    completion(.failure(error!))
                }
                return
            }

            let files = FileObjectsMapper.files(from: fileObjects)

            completionQueue.async {
                completion(.success(files))
            }
        }

        return nil
    }

    func contents(path: String, offset: Int64, length: Int, completion: @escaping (Result<Data>) -> Void) -> OperationHandle? {
        provider.contents(path: path, offset: offset, length: length - 1) { [unowned completionQueue] (data, error) in
            guard error == nil else {
                completionQueue.async {
                    completion(.failure(error!))
                }
                return
            }

            completionQueue.async {
                completion(.success(data!))
            }
        }
        return nil
    }
}

private indirect enum FileNode {
    case file(String)
    case directory(String, [FileNode])
}
