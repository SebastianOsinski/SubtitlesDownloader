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
        let name = wrap(method.name, inTag: "methodName")
        let parameters = wrap("", inTag: "params")

        return wrap(name + parameters, inTag: "methodCall")
    }

    private func wrap(_ value: String, inTag tag: String) -> String {
        return "<\(tag)>\(value)</\(tag)>"
    }
}
