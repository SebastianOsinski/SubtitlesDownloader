//
//  MethodSerializer.swift
//  SubtitlesDownloader
//
//  Created by Sebastian Osiński on 31/01/2017.
//  Copyright © 2017 Sebastian Osiński. All rights reserved.
//

import Foundation

class MethodSerializer {

    private let valueSerializer: ValueSerializer
    private let indentationStep: String

    init(indentationStepLevel: Int = 2) {
        valueSerializer = ValueSerializer(indentationStepLevel: indentationStepLevel)
        indentationStep = String(repeating: " ", count: indentationStepLevel)
    }

    func serialize<M: Method>(_ method: M) -> String {
        let name = wrap(method.name, inTag: "methodName")

        let serializedParameters = method.parameters
            .lazy
            .map(serializeParameter)
            .joined(separator: "\n")

        let lines = [
            "<methodCall>",
            indentationStep + name,
            indentationStep + "<params>",
            serializedParameters,
            indentationStep + "</params>",
            "</methodCall>"
        ]

        return lines
            .lazy
            .filter { !$0.isEmpty }
            .joined(separator: "\n")
    }

    private func serializeParameter(_ parameter: Value) -> String {
        return [
            indentationStep + indentationStep + "<param>",
            valueSerializer.serialize(parameter, indentationLevel: 3),
            indentationStep + indentationStep + "</param>"
        ].joined(separator: "\n")
    }

    private func wrap(_ value: String, inTag tag: String) -> String {
        return "<\(tag)>\(value)</\(tag)>"
    }
}
