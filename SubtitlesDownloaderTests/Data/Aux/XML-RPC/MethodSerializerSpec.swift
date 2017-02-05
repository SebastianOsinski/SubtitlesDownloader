//
//  MethodSerializerSpec.swift
//  SubtitlesDownloader
//
//  Created by Sebastian Osiński on 31/01/2017.
//  Copyright © 2017 Sebastian Osiński. All rights reserved.
//

import Quick
import Nimble
import SWXMLHash
@testable import SubtitlesDownloader

class MethodSerializerSpec: QuickSpec {
    
    override func spec() {

        describe("MethodSerializer") {

            var sut: MethodSerializer!

            beforeEach {
                sut = MethodSerializer()
            }

            it("serializes method without parameters") {
                let method = TestMethod(parameters: [])

                expect(sut.serialize(method)).to(equal(String(
                    "<methodCall>",
                    "  <methodName>TestMethod</methodName>",
                    "  <params>",
                    "  </params>",
                    "</methodCall>"
                )))
            }

            it("serializes method with one parameter") {
                let method = TestMethod(parameters: [.int(1)])

                expect(sut.serialize(method)).to(equal(String(
                    "<methodCall>",
                    "  <methodName>TestMethod</methodName>",
                    "  <params>",
                    "    <param>",
                    "      <value><integer>1</integer></value>",
                    "    </param>",
                    "  </params>",
                    "</methodCall>"
                )))
            }

            it("serializes method with multiple parameters") {
                let method = TestMethod(parameters: [.int(1), .double(1.0), .bool(true)])

                expect(sut.serialize(method)).to(equal(String(
                    "<methodCall>",
                    "  <methodName>TestMethod</methodName>",
                    "  <params>",
                    "    <param>",
                    "      <value><integer>1</integer></value>",
                    "    </param>",
                    "    <param>",
                    "      <value><double>1.0</double></value>",
                    "    </param>",
                    "    <param>",
                    "      <value><boolean>1</boolean></value>",
                    "    </param>",
                    "  </params>",
                    "</methodCall>"
                )))
            }
        }
    }
}

struct TestMethod: SubtitlesDownloader.Method {

    struct Response: MethodResponse {

        init(xml: XMLIndexer) {
            
        }
    }

    static let name = "TestMethod"

    let parameters: [Value]
}

