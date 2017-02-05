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

    func logIn(credentials: (user: String, password: String)?, completion: (Result<Void>) -> Void) {
        notImplemented()
    }

    func logOut(completion: (Result<Void>) -> Void) {
        notImplemented()
    }

    func search(hash: MovieHash, languages: [String], completion: (Result<[Subtitles]>) -> Void) {
        notImplemented()
    }
}


struct ServerInfoMethod: Method {

    typealias Response = ServerInfoResponse

    let name = "ServerInfo"

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
