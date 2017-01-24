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
        .directory(
            name: "",
            files: [
                .file(name: "A"),
                .file(name: "B"),
                .file(name: "C"),
                .directory(
                    name: "dir",
                    files: [
                        .file(name: "D")
                    ])
            ]
        )

    func contentsOfDirectory(path: String, completion: (Result<[File]>) -> Void) -> OperationHandle? {
        let files = [
            File(name: "A", path: "", type: .regular),
            File(name: "B", path: "", type: .regular),
            File(name: "C", path: "", type: .regular),
            File(name: "D", path: "", type: .regular),
            File(name: "E", path: "", type: .regular)
        ]

        completion(.success(files))

        return nil
    }

    func contents(path: String, offset: Int64, length: Int, completion: (Result<Data>) -> Void) -> OperationHandle? {
        return nil
    }
}

private indirect enum FileNode {
    case file(name: String)
    case directory(name: String, files: [FileNode])
}
