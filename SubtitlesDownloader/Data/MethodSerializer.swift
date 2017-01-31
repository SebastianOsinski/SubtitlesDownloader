//
//  MethodSerializer.swift
//  SubtitlesDownloader
//
//  Created by Sebastian Osiński on 31/01/2017.
//  Copyright © 2017 Sebastian Osiński. All rights reserved.
//

import Foundation

class MethodSerializer {

    func serialize(_ method: Method) -> String {
        let name = wrapInXmlTag(value: method.name, tag: "methodName")
        let parameters = wrapInXmlTag(value: "", tag: "params")

        return wrapInXmlTag(value: name + parameters, tag: "methodCall")
    }

    private func wrapInXmlTag(value: String, tag: String) -> String {
        return "<\(tag)>\(value)</\(tag)>"
    }
}
