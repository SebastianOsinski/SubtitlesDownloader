//
//  FileListConnector.swift
//  SubtitlesDownloader
//
//  Created by Sebastian Osiński on 23/01/2017.
//  Copyright © 2017 Sebastian Osiński. All rights reserved.
//

import UIKit

protocol FileListConnector: class {
    func navigateToDirectory(atPath path: String)
    func navigateToVideoFile(atPath path: String)
    func navigateToOtherFile(atPath path: String)
}

class VideoFileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
    }
}
