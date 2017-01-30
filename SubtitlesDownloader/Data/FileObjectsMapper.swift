//
//  FileObjectsMapper.swift
//  SubtitlesDownloader
//
//  Created by Sebastian Osiński on 30/01/2017.
//  Copyright © 2017 Sebastian Osiński. All rights reserved.
//

import Foundation
import FileProvider

struct FileObjectsMapper {

    static func files(from fileObjects: [FileObject]) -> [File] {
        return fileObjects.flatMap { fileObject -> File? in
            let type: File.FileType

            switch fileObject.fileType {
            case .regular:
                type = .regular
            case .directory:
                type = .directory
            default:
                assertionFailure("Unexpected file type!")
                return nil
            }

            return File(name: fileObject.name, path: fileObject.path, type: type, size: fileObject.size)
        }
    }
}
