//
//  SubtitlesGateway.swift
//  SubtitlesDownloader
//
//  Created by Sebastian Osiński on 30/01/2017.
//  Copyright © 2017 Sebastian Osiński. All rights reserved.
//

import Foundation
import RxSwift

enum LogInError: Error {
    case unknown
}

enum NoError: Error {}

protocol SubtitlesGateway {
    func logIn(credentials: (user: String, password: String)?) -> Single<Result<Void, LogInError>>
    func logOut() -> Single<Result<Void, NoError>>
    func search(hash: MovieHash, languages: [String]) -> Single<Result<[Subtitles], NoError>>
}

struct Subtitles {
    let fileName: String
    let releaseName: String
    let format: String
    let downloadUrl: URL
}
