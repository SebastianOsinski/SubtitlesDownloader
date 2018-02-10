//
//  UITableViewCell+ReusableView.swift
//  SubtitlesDownloader
//
//  Created by Sebastian Osiński on 24/01/2017.
//  Copyright © 2017 Sebastian Osiński. All rights reserved.
//

import UIKit

extension UITableViewCell: ReusableView {

    static var defaultReuseIdentifier: String {
        return String(describing: self)
    }
}
