//
//  MethodSerializerSpec.swift
//  SubtitlesDownloader
//
//  Created by Sebastian Osiński on 31/01/2017.
//  Copyright © 2017 Sebastian Osiński. All rights reserved.
//

import Quick
import Nimble
@testable import SubtitlesDownloader

class MethodSerializerSpec: QuickSpec {
    
    override func spec() {

        describe("MethodSerializer") {

            var sut: MethodSerializer!

            beforeEach {
                sut = MethodSerializer()
            }

            it("serializes method without parameters") {
                let method = TestMethod(name: "TestMethod", parameters: [])

                let expectedResult =
                    "<methodCall>" +
                    "<methodName>TestMethod</methodName>" +
                    "<params></params>" +
                    "</methodCall>"

                expect(sut.serialize(method)).to(equal(expectedResult))
            }
        }
    }
}

struct TestMethod: SubtitlesDownloader.Method {

    let name: String
    let parameters: [Value]
}
