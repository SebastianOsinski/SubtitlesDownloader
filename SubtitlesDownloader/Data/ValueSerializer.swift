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

    private let indentation = "  "

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
        return serialize(value, indentationLevel: 0)
    }

    private func serialize(_ value: Value, indentationLevel: Int) -> String {
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
        case .array(let values):
            serializedValue = serializeArray(values, indentationLevel: indentationLevel + 1)
        default:
            notImplemented()
        }

        let currentIndentation = String(repeating: indentation, count: indentationLevel)
        return currentIndentation + wrap(serializedValue, inTag: "value")
    }

    private func wrap(_ value: String, inTag tag: String) -> String {
        return "<\(tag)>\(value)</\(tag)>"
    }

    private func serializeArray(_ array: [Value], indentationLevel: Int) -> String {
        let valuesIndentationLevel = indentationLevel + 2

        let serializedValues = array.map { value in
            serialize(value, indentationLevel: valuesIndentationLevel)
        }.joined(separator: "\n")

        let currentIndentation = String(repeating: indentation, count: indentationLevel)

        let lines = [
            currentIndentation + "<array>",
            currentIndentation + indentation + "<data>",
            serializedValues,
            currentIndentation + indentation + "</data>",
            currentIndentation + "</array>"
        ]

        let result = lines
            .lazy
            .filter { !$0.isEmpty }
            .joined(separator: "\n")

        return "\n" + result + "\n"
    }
}
