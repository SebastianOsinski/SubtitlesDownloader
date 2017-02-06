//
//  XmlResponseSpec.swift
//  SubtitlesDownloader
//
//  Created by Sebastian Osiński on 06/02/2017.
//  Copyright © 2017 Sebastian Osiński. All rights reserved.
//

import Quick
import Nimble
@testable import SubtitlesDownloader

class XmlResponseSpec: QuickSpec {

    override func spec() {

        describe("XmlResponse") {

            it("returns integer value from response with integer value") {
                let data = String(
                    "<methodResponse>",
                    "  <params>",
                    "    <param>",
                    "      <value><integer>1</integer></value>",
                    "    </param>",
                    "  </params>",
                    "</methodResponse>"
                ).data(using: .utf8)!

                let response = XmlResponse(data: data)

                expect(response.int).to(equal(1))
            }

            it("returns double value from response with double value") {
                let data = String(
                    "<methodResponse>",
                    "  <params>",
                    "    <param>",
                    "      <value><double>1.1</double></value>",
                    "    </param>",
                    "  </params>",
                    "</methodResponse>"
                    ).data(using: .utf8)!

                let response = XmlResponse(data: data)

                expect(response.double).to(equal(1.1))
            }

            it("returns bool value from response with boolean value") {
                let data = String(
                    "<methodResponse>",
                    "  <params>",
                    "    <param>",
                    "      <value><boolean>1</boolean></value>",
                    "    </param>",
                    "  </params>",
                    "</methodResponse>"
                    ).data(using: .utf8)!

                let response = XmlResponse(data: data)

                expect(response.bool).to(equal(true))
            }

            it("returns string value from response with string value") {
                let data = String(
                    "<methodResponse>",
                    "  <params>",
                    "    <param>",
                    "      <value><string>TestResponse</string></value>",
                    "    </param>",
                    "  </params>",
                    "</methodResponse>"
                    ).data(using: .utf8)!

                let response = XmlResponse(data: data)

                expect(response.string).to(equal("TestResponse"))
            }
        }
    }
}
