//
//  ValueSerializerSpec.swift
//  SubtitlesDownloader
//
//  Created by Sebastian Osiński on 31/01/2017.
//  Copyright © 2017 Sebastian Osiński. All rights reserved.
//

import Quick
import Nimble
@testable import SubtitlesDownloader

class ValueSerializerSpec: QuickSpec {

    override func spec() {

        describe("ValueSerializer") {

            var sut: ValueSerializer!

            beforeEach {
                sut = ValueSerializer()
            }

            it("serializes int") {
                expect(sut.serialize(.int(1))).to(equal("<value><integer>1</integer></value>"))
            }

            it("serializes double") {
                expect(sut.serialize(.double(1.1))).to(equal("<value><double>1.1</double></value>"))
            }

            it("serializes boolean") {
                expect(sut.serialize(.bool(true))).to(equal("<value><boolean>1</boolean></value>"))
                expect(sut.serialize(.bool(false))).to(equal("<value><boolean>0</boolean></value>"))
            }

            it("serializes string") {
                expect(sut.serialize(.string(""))).to(equal("<value><string></string></value>"))
                expect(sut.serialize(.string("Test"))).to(equal("<value><string>Test</string></value>"))
            }

            it("serializes date") {
                let date = Date(timeIntervalSince1970: 1485882317)
                expect(sut.serialize(.date(date))).to(equal("<value><dateTime.iso8601>20170131T17:05:17</dateTime.iso8601></value>"))
            }

            it("serializes data") {
                let data = Data(base64Encoded: "AQIDBAU=")!
                expect(sut.serialize(.base64(data))).to(equal("<value><base64>AQIDBAU=</base64></value>"))
            }

            it("serializes empty array") {
                expect(sut.serialize(.array([]))).to(equal(String(
                    "<value>",
                    "  <array>",
                    "    <data>",
                    "    </data>",
                    "  </array>",
                    "</value>"
                )))
            }

            it("serializes array with one int inside") {
                expect(sut.serialize(.array([.int(1)]))).to(equal(String(
                    "<value>",
                    "  <array>",
                    "    <data>",
                    "      <value><integer>1</integer></value>",
                    "    </data>",
                    "  </array>",
                    "</value>"
                )))
            }

            it("serializes array with multiple values inside") {
                expect(sut.serialize(.array([.int(1), .double(1.1), .bool(true), .string("Test")]))).to(equal(String(
                    "<value>",
                    "  <array>",
                    "    <data>",
                    "      <value><integer>1</integer></value>",
                    "      <value><double>1.1</double></value>",
                    "      <value><boolean>1</boolean></value>",
                    "      <value><string>Test</string></value>",
                    "    </data>",
                    "  </array>",
                    "</value>"
                )))
            }

            it("serializes nested arrays") {
                let value: Value =
                    .array([
                        .array([
                            .int(1), .double(1.1), .bool(true), .string("Test")
                        ])
                    ])

                expect(sut.serialize(value)).to(equal(String(
                    "<value>",
                    "  <array>",
                    "    <data>",
                    "      <value>",
                    "        <array>",
                    "          <data>",
                    "            <value><integer>1</integer></value>",
                    "            <value><double>1.1</double></value>",
                    "            <value><boolean>1</boolean></value>",
                    "            <value><string>Test</string></value>",
                    "          </data>",
                    "        </array>",
                    "      </value>",
                    "    </data>",
                    "  </array>",
                    "</value>"
                )))
            }

            it("serializes array of arrays") {
                let value: Value =
                    .array([
                        .array([
                            .int(1), .double(1.1), .bool(true), .string("Test")
                        ]),
                        .array([
                            .int(1), .double(1.1), .bool(true), .string("Test")
                        ])
                    ])

                expect(sut.serialize(value)).to(equal(String(
                    "<value>",
                    "  <array>",
                    "    <data>",
                    "      <value>",
                    "        <array>",
                    "          <data>",
                    "            <value><integer>1</integer></value>",
                    "            <value><double>1.1</double></value>",
                    "            <value><boolean>1</boolean></value>",
                    "            <value><string>Test</string></value>",
                    "          </data>",
                    "        </array>",
                    "      </value>",
                    "      <value>",
                    "        <array>",
                    "          <data>",
                    "            <value><integer>1</integer></value>",
                    "            <value><double>1.1</double></value>",
                    "            <value><boolean>1</boolean></value>",
                    "            <value><string>Test</string></value>",
                    "          </data>",
                    "        </array>",
                    "      </value>",
                    "    </data>",
                    "  </array>",
                    "</value>"
                )))
            }

            it("serializes empty struct") {
                expect(sut.serialize(.struct([]))).to(equal(String(
                    "<value>",
                    "  <struct>",
                    "  </struct>",
                    "</value>"
                )))
            }

            it("serializes struct with one member") {
                let value: Value = .struct([
                    (name: "Test", value: .int(1))
                ])

                expect(sut.serialize(value)).to(equal(String(
                    "<value>",
                    "  <struct>",
                    "    <member>",
                    "      <name>Test</name>",
                    "      <value><integer>1</integer></value>",
                    "    </member>",
                    "  </struct>",
                    "</value>"
                )))
            }

            it("serializes struct with multiple members") {
                let value: Value = .struct([
                    (name: "TestInteger", value: .int(1)),
                    (name: "TestDouble", value: .double(1.1)),
                    (name: "TestString", value: .string("Test"))
                ])

                expect(sut.serialize(value)).to(equal(String(
                    "<value>",
                    "  <struct>",
                    "    <member>",
                    "      <name>TestInteger</name>",
                    "      <value><integer>1</integer></value>",
                    "    </member>",
                    "    <member>",
                    "      <name>TestDouble</name>",
                    "      <value><double>1.1</double></value>",
                    "    </member>",
                    "    <member>",
                    "      <name>TestString</name>",
                    "      <value><string>Test</string></value>",
                    "    </member>",
                    "  </struct>",
                    "</value>"
                )))
            }
        }
    }
}

