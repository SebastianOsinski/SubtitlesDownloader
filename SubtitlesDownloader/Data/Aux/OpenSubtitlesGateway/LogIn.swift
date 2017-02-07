//
//  LogIn.swift
//  SubtitlesDownloader
//
//  Created by Sebastian Osiński on 05/02/2017.
//  Copyright © 2017 Sebastian Osiński. All rights reserved.
//

import Foundation

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

    init?(xml: XmlResponse) {
        guard let token = xml.struct?["token"]?.string else {
            return nil
        }

        self.token = token
    }
}
