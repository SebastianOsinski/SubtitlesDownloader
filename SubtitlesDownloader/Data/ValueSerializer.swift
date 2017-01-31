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

    private let indentationStep = "  "

    private var indentationCache = [""]

    init(indentationCachePrefill: Int? = 5) {
        dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [
            .withYear,
            .withMonth,
            .withDay,
            .withTime,
            .withColonSeparatorInTime
        ]

        if let level = indentationCachePrefill {
            _ = indentation(for: level)
        }
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
        case .struct(let values):
            serializedValue = serializeStruct(values, indentationLevel: indentationLevel + 1)
        }

        let currentIndentation = indentation(for: indentationLevel)
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

        let currentIndentation = indentation(for: indentationLevel)

        let lines = [
            currentIndentation + "<array>",
            currentIndentation + indentationStep + "<data>",
            serializedValues,
            currentIndentation + indentationStep + "</data>",
            currentIndentation + "</array>"
        ]

        let result = lines
            .lazy
            .filter { !$0.isEmpty }
            .joined(separator: "\n")

        return "\n" + result + "\n" + indentation(for: indentationLevel - 1)
    }

    private func serializeStruct(_ members: [Value.Member], indentationLevel: Int) -> String {
        let structIndentation = indentation(for: indentationLevel)
        let memberIndentationLevel = indentationLevel + 1

        let serializedMembers = members.map { member in
            serializeMember(member, indentationLevel: memberIndentationLevel)
        }.joined(separator: "\n")

        let lines = [
            structIndentation + "<struct>",
            serializedMembers,
            structIndentation + "</struct>"
        ]

        let result = lines
            .filter { !$0.isEmpty }
            .joined(separator: "\n")

        return "\n" + result + "\n" + indentation(for: indentationLevel - 1)
    }

    private func serializeMember(_ member: Value.Member, indentationLevel: Int) -> String {
        let memberIndentation = indentation(for: indentationLevel)
        let nameIndentation = memberIndentation + indentationStep
        let valueIndentationLevel = indentationLevel + 1

        let lines = [
            memberIndentation + "<member>",
            nameIndentation + wrap(member.name, inTag: "name"),
            serialize(member.value, indentationLevel: valueIndentationLevel),
            memberIndentation + "</member>"
        ]

        return lines.joined(separator: "\n")
    }

    private func indentation(for level: Int) -> String {
        if level < indentationCache.count {
            return indentationCache[level]
        }

        let count = indentationCache.count

        var indentation = indentationCache.last!

        for _ in count...level {
            indentation += indentationStep
            indentationCache.append(indentation)
        }

        return indentation
    }
}
