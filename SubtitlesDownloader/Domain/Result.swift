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

    var success: SuccessType? {
        switch self {
        case .success(let value):
            return value
        case .failure:
            return nil
        }
    }
}

typealias ResultCallback<T> = (Result<T>) -> Void
