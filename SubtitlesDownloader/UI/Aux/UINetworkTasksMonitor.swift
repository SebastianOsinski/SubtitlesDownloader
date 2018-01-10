//
//  UINetworkTasksMonitor.swift
//  SubtitlesDownloader
//
//  Created by Sebastian Osiński on 30/01/2017.
//  Copyright © 2017 Sebastian Osiński. All rights reserved.
//

import UIKit

class UINetworkTasksMonitor: NetworkTasksMonitor {

    private let queue = DispatchQueue(label: "xyz.osinski.SubtitlesDownloader.networkTasksMonitor")

    private var counter = 0 {
        didSet {
            DispatchQueue.main.sync { UIApplication.shared.isNetworkActivityIndicatorVisible = counter > 0 }
        }
    }

    func increment() {
        queue.async {
            self.counter += 1
        }
    }

    func decrement() {
        queue.async {
            self.counter = max(self.counter - 1, 0)
        }
    }
}
