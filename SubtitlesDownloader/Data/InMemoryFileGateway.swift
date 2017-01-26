//
//  InMemoryFileGateway.swift
//  SubtitlesDownloader
//
//  Created by Sebastian Osiński on 23/01/2017.
//  Copyright © 2017 Sebastian Osiński. All rights reserved.
//

import Foundation

class InMemoryFileGateway: FileGateway {

    private let tree: FileNode =
        .directory("", [
            .file("A"),
            .file("B"),
            .file("C"),
            .directory("dir", [
                .file("D")
            ])
        ])

    func contentsOfDirectory(path: String, completion: @escaping (Result<[File]>) -> Void) -> OperationHandle? {
        let files = [
            File(name: "A", path: "", type: .directory, size: 0),
            File(name: "B", path: "", type: .directory, size: 0),
            File(name: "C", path: "", type: .directory, size: 0),
            File(name: "D", path: "", type: .directory, size: 0),
            File(name: "E", path: "", type: .directory, size: 0)
        ]

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            completion(.success(files))
        }

        return nil
    }

    func contents(path: String, offset: Int64, length: Int, completion: @escaping (Result<Data>) -> Void) -> OperationHandle? {
        return nil
    }
}

private indirect enum FileNode {
    case file(String)
    case directory(String, [FileNode])
}
