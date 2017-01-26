//
//  WebDavFileGateway.swift
//  SubtitlesDownloader
//
//  Created by Sebastian Osiński on 26/01/2017.
//  Copyright © 2017 Sebastian Osiński. All rights reserved.
//

import Foundation
import FileProvider

class WebDavFileGateway: FileGateway {

    private let provider: WebDAVFileProvider
    private let completionQueue: DispatchQueue = .main

    init(baseUrl: URL, user: String, password: String) {
        self.provider = WebDAVFileProvider(
            baseURL: baseUrl,
            credential: URLCredential(user: user, password: password, persistence: .none)
        )!
    }

    func contentsOfDirectory(path: String, completion: @escaping (Result<[File]>) -> Void) -> OperationHandle? {
        provider.contentsOfDirectory(path: path) { [unowned completionQueue] (fileObjects, error) in
            guard error == nil else {
                completionQueue.async {
                    completion(.failure(error!))
                }
                return
            }

            let files = fileObjects.flatMap { fileObject -> File? in
                let type: File.FileType

                switch fileObject.fileType {
                case .regular:
                    type = .regular
                case .directory:
                    type = .directory
                default:
                    assertionFailure("Unexpected file type!")
                    return nil
                }

                return File(name: fileObject.name, path: fileObject.path, type: type, size: 0)
            }

            completionQueue.async {
                completion(.success(files))
            }
        }

        return nil
    }

    func contents(path: String, offset: Int64, length: Int, completion: @escaping (Result<Data>) -> Void) -> OperationHandle? {
        return nil
    }
}
