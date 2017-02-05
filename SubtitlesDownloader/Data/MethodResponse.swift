//
//  MethodResponse.swift
//  SubtitlesDownloader
//
//  Created by Sebastian Osiński on 05/02/2017.
//  Copyright © 2017 Sebastian Osiński. All rights reserved.
//

import SWXMLHash

protocol MethodResponse {
    init?(xml: XMLIndexer)
}
