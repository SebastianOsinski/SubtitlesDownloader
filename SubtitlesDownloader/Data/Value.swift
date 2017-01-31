//
//  Value.swift
//  SubtitlesDownloader
//
//  Created by Sebastian Osiński on 31/01/2017.
//  Copyright © 2017 Sebastian Osiński. All rights reserved.
//


import Foundation

indirect enum Value {
    case int(Int)
    case double(Double)
    case bool(Bool)
    case string(String)
    case date(Date)
    case base64(Data)
    case array([Value])
    case `struct`([String: Value])
}
