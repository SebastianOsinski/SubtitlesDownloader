//
//  Result.swift
//  SubtitlesDownloader
//
//  Created by Sebastian Osiński on 23/01/2017.
//  Copyright © 2017 Sebastian Osiński. All rights reserved.
//

protocol ResultType {
    associatedtype Value
    associatedtype Error: Swift.Error

    var success: Value? { get }
    var error: Error? { get }
}

enum Result<Value, Error: Swift.Error>: ResultType {
    case success(Value)
    case failure(Error)

    var success: Value? {
        switch self {
        case .success(let value):
            return value
        case .failure:
            return nil
        }
    }

    var error: Error? {
        switch self {
        case .failure(let error):
            return error
        case .success:
            return nil
        }
    }

    func map<T>(_ transform: (Value) -> T) -> Result<T, Error> {
        switch self {
        case .success(let value):
            return .success(transform(value))
        case .failure(let error):
            return .failure(error)
        }
    }

    func mapError<E: Swift.Error>(_ transform: (Error) -> E) -> Result<Value, E> {
        switch self {
        case .failure(let error):
            return .failure(transform(error))
        case .success(let value):
            return .success(value)
        }
    }
}
