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

    static let name = "ServerInfo"

    var parameters: [Parameter] = []
}

class MethodBodyBuilder {

    func buildBody<M: Method>(method: M) -> String {
        let methodName = wrapInXmlTag(
            value: M.name,
            tag: "methodName"
        )

        return methodName
    }

    private func wrapInXmlTag(value: String, tag: String) -> String {
        return "<\(tag)>\(value)</\(tag)>"
    }
}
