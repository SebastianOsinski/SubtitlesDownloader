//
//  FileObjectsMapper.swift
//  SubtitlesDownloader
//
//  Created by Sebastian Osiński on 30/01/2017.
//  Copyright © 2017 Sebastian Osiński. All rights reserved.
//

import Foundation
import FilesProvider

struct FileObjectsMapper {

    static func files(from fileObjects: [FileObject]) -> [File] {
        return fileObjects.flatMap { fileObject -> File? in
            let fileObjectType = fileObject.type
            let type: File.FileType

            switch fileObjectType {
            case URLFileResourceType.regular:
                type = .regular
            case URLFileResourceType.directory:
                type = .directory
            default:
                assertionFailure("Unexpected file type!")
                return nil
            }

            return File(name: fileObject.name, path: fileObject.path, type: type, size: fileObject.size)
        }
    }
}
