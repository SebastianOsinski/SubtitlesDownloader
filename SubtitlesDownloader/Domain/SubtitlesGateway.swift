//
//  SubtitlesGateway.swift
//  SubtitlesDownloader
//
//  Created by Sebastian Osiński on 30/01/2017.
//  Copyright © 2017 Sebastian Osiński. All rights reserved.
//

import Foundation

typealias LogInCompletion = (Result<Void>) -> Void
typealias LogOutCompletion = (Result<Void>) -> Void
typealias SubtitlesSearchCompletion = (Result<[Subtitles]>) -> Void

protocol SubtitlesGateway {
    func logIn(credentials: (user: String, password: String)?, completion: @escaping LogInCompletion)
    func logOut(completion: @escaping LogOutCompletion)
    func search(hash: MovieHash, languages: [String], completion: @escaping SubtitlesSearchCompletion)
}

struct Subtitles {
    let fileName: String
    let releaseName: String
    let format: String
    let downloadUrl: URL
}
