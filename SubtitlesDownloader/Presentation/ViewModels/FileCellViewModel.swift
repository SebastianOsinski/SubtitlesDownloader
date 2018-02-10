//
//  FileCellViewModel.swift
//  SubtitlesDownloader
//
//  Created by Sebastian Osiński on 10.02.2018.
//  Copyright © 2018 Sebastian Osiński. All rights reserved.
//

import Foundation

struct FileCellViewModel {

    let name: String

    init(file: File) {
        self.name = file.name
    }
}
