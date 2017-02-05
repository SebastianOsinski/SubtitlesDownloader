//
//  String+lines.swift
//  SubtitlesDownloader
//
//  Created by Sebastian Osiński on 05/02/2017.
//  Copyright © 2017 Sebastian Osiński. All rights reserved.
//

extension String {

    init(_ lines: String...) {
        self = lines.joined(separator: "\n")
    }
}
