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

            it("serializes int value") {
                expect(sut.serialize(.int(1))).to(equal("<value><integer>1</integer></value>"))
            }

            it("serializes double value") {
                expect(sut.serialize(.double(1.1))).to(equal("<value><double>1.1</double></value>"))
            }

            it("serializes boolean value") {
                expect(sut.serialize(.bool(true))).to(equal("<value><boolean>1</boolean></value>"))
                expect(sut.serialize(.bool(false))).to(equal("<value><boolean>0</boolean></value>"))
            }

            it("serializes string value") {
                expect(sut.serialize(.string(""))).to(equal("<value><string></string></value>"))
                expect(sut.serialize(.string("Test"))).to(equal("<value><string>Test</string></value>"))
            }
        }
    }
}
