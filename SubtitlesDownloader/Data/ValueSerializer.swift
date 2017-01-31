//
//  ValueSerializer.swift
//  SubtitlesDownloader
//
//  Created by Sebastian Osiński on 31/01/2017.
//  Copyright © 2017 Sebastian Osiński. All rights reserved.
//

import Foundation

class ValueSerializer {

    private let dateFormatter: ISO8601DateFormatter

    init() {
        dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [
            .withYear,
            .withMonth,
            .withDay,
            .withTime,
            .withColonSeparatorInTime
        ]
    }

    func serialize(_ value: Value) -> String {
        let serializedValue: String
        switch value {
        case .int(let value):
            serializedValue = wrap("\(value)", inTag: "integer")
        case .double(let value):
            serializedValue = wrap("\(value)", inTag: "double")
        case .bool(let value):
            serializedValue = wrap("\(value ? 1 : 0)", inTag: "boolean")
        case .string(let value):
            serializedValue = wrap(value, inTag: "string")
        case .date(let value):
            serializedValue = wrap(dateFormatter.string(from: value), inTag: "dateTime.iso8601")
        case .base64(let value):
            serializedValue = wrap(value.base64EncodedString(), inTag: "base64")
        default:
            notImplemented()
        }
        return wrap(serializedValue, inTag: "value")
    }

    private func wrap(_ value: String, inTag tag: String) -> String {
        return "<\(tag)>\(value)</\(tag)>"
    }
}
