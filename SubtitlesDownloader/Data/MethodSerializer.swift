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

    func serialize(_ method: Method) -> String {
        let name = wrap(method.name, inTag: "methodName")
        let parameters = wrap("", inTag: "params")

        let lines = [
            "<methodCall>",
            indentationStep + name,
            indentationStep + "<params>",
            indentationStep + "</params>",
            "</methodCall>"
        ]

        return lines
            .lazy
            .filter { !$0.isEmpty }
            .joined(separator: "\n")
    }

    private func wrap(_ value: String, inTag tag: String) -> String {
        return "<\(tag)>\(value)</\(tag)>"
    }
}
