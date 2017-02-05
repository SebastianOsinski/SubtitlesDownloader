//
//  NetworkTasksMonitor.swift
//  SubtitlesDownloader
//
//  Created by Sebastian Osiński on 30/01/2017.
//  Copyright © 2017 Sebastian Osiński. All rights reserved.
//

protocol NetworkTasksMonitor: class {
    func increment()
    func decrement()
}
