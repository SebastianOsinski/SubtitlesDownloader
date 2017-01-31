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

    let name = "ServerInfo"

    let parameters: [Value] = []
}
