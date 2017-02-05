//
//  OpenSubtitlesGateway.swift
//  SubtitlesDownloader
//
//  Created by Sebastian Osiński on 30/01/2017.
//  Copyright © 2017 Sebastian Osiński. All rights reserved.
//

import Foundation
import SWXMLHash

func notImplemented(file: StaticString = #file, line: UInt = #line) -> Never {
    fatalError("Feature not implemented", file: file, line: line)
}

class OpenSubtitlesGateway: SubtitlesGateway {

    private let apiClient = XmlRpcApiClient(url: URL(string: "http://api.opensubtitles.org/xml-rpc")!)
    private let userAgent = "OSTestUserAgentTemp"

    private var token: String?

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


struct ServerInfoMethod: Method {

    typealias Response = ServerInfoResponse

    static let name = "ServerInfo"

    let parameters: [Value] = []
}

struct ServerInfoResponse: MethodResponse {

    let moviesTotal: Int

    init?(xml: XMLIndexer) {

        let moviesTotal = xml["struct"]["member"].all.first(where: { xml in
            xml["name"].element?.text ?? "" == "movies_total"
        })?["value"]["string"].element?.text.flatMap { Int($0) }

        guard let total = moviesTotal else {
            return nil
        }

        self.moviesTotal = total
    }
}
