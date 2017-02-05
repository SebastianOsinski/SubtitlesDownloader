//
//  OpenSubtitlesGateway.swift
//  SubtitlesDownloader
//
//  Created by Sebastian Osiński on 30/01/2017.
//  Copyright © 2017 Sebastian Osiński. All rights reserved.
//

import Foundation

func notImplemented(file: StaticString = #file, line: UInt = #line) -> Never {
    fatalError("Feature not implemented", file: file, line: line)
}

class OpenSubtitlesGateway: SubtitlesGateway {

    private let apiClient: XmlRpcApiClient
    private let userAgent = "OSTestUserAgentTemp"

    private var token: String?

    init(apiClient: XmlRpcApiClient) {
        self.apiClient = apiClient
    }

    func logIn(credentials: (user: String, password: String)?, completion: @escaping (Result<Void>) -> Void) {
        let method = LogIn(
            user: credentials?.user ?? "",
            password: credentials?.password ?? "",
            language: "en",
            userAgent: userAgent
        )

        apiClient.callMethod(method) { [weak self] result in
            switch result {
            case .success(let token):
                self?.token = token.token
                completion(.success())
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func logOut(completion: @escaping (Result<Void>) -> Void) {
        notImplemented()
    }

    func search(hash: MovieHash, languages: [String], completion: @escaping (Result<[Subtitles]>) -> Void) {
        notImplemented()
    }
}
