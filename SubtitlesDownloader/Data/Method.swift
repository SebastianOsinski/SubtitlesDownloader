//
//  Method.swift
//  SubtitlesDownloader
//
//  Created by Sebastian Osiński on 31/01/2017.
//  Copyright © 2017 Sebastian Osiński. All rights reserved.
//

protocol Method {
    var name: String { get }
    var parameters: [Value] { get }
}
