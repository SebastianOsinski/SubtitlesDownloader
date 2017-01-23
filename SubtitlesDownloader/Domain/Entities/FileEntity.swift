//
//  FileEntity.swift
//  SubtitlesDownloader
//
//  Created by Sebastian Osiński on 23/01/2017.
//  Copyright © 2017 Sebastian Osinski. All rights reserved.
//

struct FileEntity {

    enum EntityType {
        case file
        case directory
    }

    let name: String
    let path: String
    let type: EntityType
}
