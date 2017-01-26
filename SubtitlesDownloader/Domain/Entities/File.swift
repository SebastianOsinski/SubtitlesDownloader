//
//  File.swift
//  SubtitlesDownloader
//
//  Created by Sebastian Osiński on 23/01/2017.
//  Copyright © 2017 Sebastian Osiński. All rights reserved.
//

struct File {

    enum FileType {
        case regular
        case directory
    }

    let name: String
    let path: String
    let type: FileType
    let size: Int64
}
