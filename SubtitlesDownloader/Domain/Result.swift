//
//  Result.swift
//  SubtitlesDownloader
//
//  Created by Sebastian Osiński on 23/01/2017.
//  Copyright © 2017 Sebastian Osiński. All rights reserved.
//

protocol ResultType {
    associatedtype SuccessType

    var success: SuccessType? { get }
}

enum Result<SuccessType>: ResultType {
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

    func map<T>(_ transform: (SuccessType) -> T) -> Result<T> {
        switch self {
        case .success(let value):
            return .success(transform(value))
        case .failure(let error):
            return .failure(error)
        }
    }
}

typealias ResultCallback<T> = (Result<T>) -> Void
