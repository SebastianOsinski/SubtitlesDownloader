//
//  Result.swift
//  SubtitlesDownloader
//
//  Created by Sebastian Osiński on 23/01/2017.
//  Copyright © 2017 Sebastian Osiński. All rights reserved.
//

enum Result<SuccessType> {
    case success(SuccessType)
    case failure(Error)
}

typealias ResultCallback<T> = (Result<T>) -> Void
