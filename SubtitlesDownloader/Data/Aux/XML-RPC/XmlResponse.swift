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

    init(data: Data) {
        self.indexer = SWXMLHash.parse(data)["methodResponse"]["params"]["param"]["value"]
    }

    fileprivate init(indexer: XMLIndexer) {
        self.indexer = indexer
    }

    var int: Int? {
        return subIndexer("integer")?.element?.text.flatMap { Int($0) }
    }

    var double: Double? {
        return subIndexer("double")?.element?.text.flatMap { Double($0) }
    }

    var bool: Bool? {
        return subIndexer("boolean")?.element?.text.map { $0 == "1" }
    }

    var string: String? {
        return subIndexer("string")?.element?.text
    }

    var date: Date? {
        return subIndexer("dateTime.iso8601")?.element?.text.flatMap(XmlRpcDateFormatter.shared.date)
    }

    var base64: Data? {
        return subIndexer("base64")?.element?.text.flatMap { Data(base64Encoded: $0) }
    }

    var `array`: ArrayXmlResponse? {
        return (subIndexer("array")?["data"]["value"]).map(ArrayXmlResponse.init)
    }

    var `struct`: StructXmlResponse? {
        return subIndexer("struct").map(StructXmlResponse.init)
    }

    private func subIndexer(_ key: String) -> XMLIndexer? {
        let subIndexer = indexer[key]

        if subIndexer.all.isEmpty {
            return nil
        }

        return subIndexer
    }
}

struct ArrayXmlResponse {

    private let indexer: XMLIndexer

    fileprivate init(indexer: XMLIndexer) {
        self.indexer = indexer
    }

    subscript(index: Int) -> XmlResponse? {
        guard index < indexer.all.count else {
            return nil
        }

        return XmlResponse(indexer: indexer.all[index])
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
        })?["value"]

        return indexer.map { XmlResponse(indexer: $0) }
    }
}
