//
//  ValueSerializerPerformanceTests.swift
//  SubtitlesDownloader
//
//  Created by Sebastian Osiński on 31/01/2017.
//  Copyright © 2017 Sebastian Osiński. All rights reserved.
//

import XCTest
@testable import SubtitlesDownloader

class ValueSerializerPerformanceTests: XCTestCase {

    private var sut: ValueSerializer!
    
    override func setUp() {
        super.setUp()
        sut = ValueSerializer()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testSerializationPerformanceOfVeryNestedArray() {
        var array: Value = .array([.array([]), .array([])])

        for _ in 0...5 {
            array = .array([Value](repeatElement(array, count: 5)))
        }

        self.measure {
            _ = self.sut.serialize(array)
        }
    }
    
    func testSerializationPerformanceOfArrayWithMixedContents() {
        let arr: Value = .array([
            .array([
                .array([.int(1), .bool(true), .array([.array([])]) ]),
                .struct([(name: "Test", value: .struct([]))]),
                .array([.int(1), .bool(true), .array([.array([])]) ]),
                .struct([(name: "Test", value: .struct([]))]),
                .array([.int(1), .bool(true), .array([.array([])]) ]),
                .struct([(name: "Test", value: .struct([]))])
            ]),
            .array([
                .array([.int(1), .bool(true), .array([.array([])]) ]),
                .struct([(name: "Test", value: .struct([]))]),
                .array([.int(1), .bool(true), .array([.array([])]) ]),
                .struct([(name: "Test", value: .struct([]))]),
                .array([.int(1), .bool(true), .array([.array([])]) ]),
                .struct([(name: "Test", value: .struct([]))])
            ])
        ])

        let arr2: Value = .array([arr, arr, arr, arr, arr])

        let value: Value = .struct([
            (name: "A", value: arr2),
            (name: "B", value: arr2),
            (name: "C", value: arr2),
            (name: "D", value: arr2)
        ])

        self.measure {
            _ = self.sut.serialize(value)
        }
    }
    
}
