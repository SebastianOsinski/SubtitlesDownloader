//
//  FileTableViewCell.swift
//  SubtitlesDownloader
//
//  Created by Sebastian Osiński on 24/01/2017.
//  Copyright © 2017 Sebastian Osiński. All rights reserved.
//

import UIKit

class FileTableViewCell: UITableViewCell {

    fileprivate let nameLabel = UILabel()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(nameLabel)

        let vMargin: CGFloat = 10.0
        let hMargin: CGFloat = 16.0

        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: vMargin),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -vMargin),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: hMargin),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -hMargin)
        ])
    }
}

extension FileTableViewCell: FileCellProtocol {

    func displayName(_ name: String) {
        nameLabel.text = name
    }
}
