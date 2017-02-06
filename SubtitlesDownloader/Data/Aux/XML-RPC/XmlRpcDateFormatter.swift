//
//  XmlRpcDateFormatter.swift
//  SubtitlesDownloader
//
//  Created by Sebastian Osiński on 06/02/2017.
//  Copyright © 2017 Sebastian Osiński. All rights reserved.
//

import Foundation

class XmlRpcDateFormatter {

    static let shared = XmlRpcDateFormatter()

    private let formatter: ISO8601DateFormatter

    init() {
        formatter = ISO8601DateFormatter()
        formatter.formatOptions = [
            .withYear,
            .withMonth,
            .withDay,
            .withTime,
            .withColonSeparatorInTime
        ]
    }

    func date(from string: String) -> Date? {
        return formatter.date(from: string)
    }

    func string(from date: Date) -> String {
        return formatter.string(from: date)
    }
}
