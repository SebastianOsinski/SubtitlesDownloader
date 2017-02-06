//
//  XmlResponse.swift
//  SubtitlesDownloader
//
//  Created by Sebastian Osiński on 06/02/2017.
//  Copyright © 2017 Sebastian Osiński. All rights reserved.
//

import Foundation
import SWXMLHash

struct XmlResponse {

    private let indexer: XMLIndexer
    private let valueIndex: Int

    init(data: Data) {
        self.indexer = SWXMLHash.lazy(data)["methodResponse"]["params"]["param"]
        self.valueIndex = 0
    }

    fileprivate init(indexer: XMLIndexer, valueIndex: Int = 0) {
        self.indexer = indexer
        self.valueIndex = valueIndex
    }

    var int: Int? {
        return value("integer").element?.text.flatMap { Int($0) }
    }

    var double: Double? {
        return value("double").element?.text.flatMap { Double($0) }
    }

    var bool: Bool? {
        return value("boolean").element?.text.map { $0 == "1" }
    }

    var string: String? {
        return value("string").element?.text
    }

    var date: Date? {
        return value("dateTime.iso8601").element?.text.flatMap(XmlRpcDateFormatter.shared.date)
    }

    var base64: Data? {
        return value("base64").element?.text.flatMap { Data(base64Encoded: $0) }
    }

    var `array`: ArrayXmlResponse {
        return ArrayXmlResponse(indexer: value("array")["data"])
    }

    var `struct`: StructXmlResponse {
        return StructXmlResponse(indexer: value("struct"))
    }

    private func value(_ type: String) -> XMLIndexer {
        return indexer["value"].all[valueIndex][type]
    }
}

struct ArrayXmlResponse {

    private let indexer: XMLIndexer

    fileprivate init(indexer: XMLIndexer) {
        self.indexer = indexer
    }

    subscript(index: Int) -> XmlResponse {
        return XmlResponse(indexer: indexer, valueIndex: index)
    }
}

struct StructXmlResponse {

    private let indexer: XMLIndexer

    fileprivate init(indexer: XMLIndexer) {
        self.indexer = indexer
    }

    subscript(name: String) -> XmlResponse? {
        let indexer = self.indexer["member"].all.first(where: { xml in
            xml["name"].element?.text == name
        })

        return indexer.map { XmlResponse(indexer: $0) }
    }
}
