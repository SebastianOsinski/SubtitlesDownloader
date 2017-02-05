//
//  LogIn.swift
//  SubtitlesDownloader
//
//  Created by Sebastian Osiński on 05/02/2017.
//  Copyright © 2017 Sebastian Osiński. All rights reserved.
//

import Foundation
import SWXMLHash

struct LogIn: Method {

    typealias Response = LogInResponse

    static let name = "LogIn"

    var parameters: [Value]

    init(user: String, password: String, language: String, userAgent: String) {
        parameters = [
            .string(user),
            .string(password),
            .string(language),
            .string(userAgent)
        ]
    }

}

struct LogInResponse: MethodResponse {

    let token: String

    init?(xml: XMLIndexer) {
        let maybeToken = xml["struct"]["member"].all.first(where: { xml in
            xml["name"].element?.text ?? "" == "token"
        })?["value"]["string"].element?.text

        guard let token = maybeToken else {
            return nil
        }

        self.token = token
    }
}
