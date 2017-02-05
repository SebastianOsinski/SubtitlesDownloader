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
        self.indexer = SWXMLHash.lazy(data)["methodResponse"]["params"]["param"]
    }

    init(indexer: XMLIndexer) {
        self.indexer = indexer
    }

    var `struct`: StructXmlResponse {
        return StructXmlResponse(indexer: value("struct"))
    }

    var int: Int? {
        return value("int").element?.text.flatMap { Int($0) }
    }

    var double: Double? {
        return value("double").element?.text.flatMap { Double($0) }
    }

    var string: String? {
        return value("string").element?.text
    }

    private func value(_ type: String) -> XMLIndexer {
        return indexer["value"][type]
    }
}

struct StructXmlResponse {

    private let indexer: XMLIndexer

    init(indexer: XMLIndexer) {
        self.indexer = indexer
    }

    func member(_ name: String) -> XmlResponse? {
        let indexer = self.indexer["member"].all.first(where: { xml in
            xml["name"].element?.text == name
        })

        return indexer.map(XmlResponse.init)
    }
}
