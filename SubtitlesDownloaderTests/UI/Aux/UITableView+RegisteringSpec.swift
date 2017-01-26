//
//  UITableView+RegisteringSpec.swift
//  SubtitlesDownloader
//
//  Created by Sebastian Osiński on 26/01/2017.
//  Copyright © 2017 Sebastian Osiński. All rights reserved.
//

import Quick
import Nimble
@testable import SubtitlesDownloader

class UITableView_RegisteringSpec: QuickSpec {

    override func spec() {

        describe("UITableView + registering") {

            let sut = UITableView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
            let dataSource = MockTableViewDataSource()
            sut.dataSource = dataSource

            sut.reloadData()

            it("correctly registers and dequeues cell") {
                sut.register(TestTableViewCell.self)
                let _: TestTableViewCell = sut.dequeueReusableCell(for: IndexPath(row: 0, section: 0))
            }
        }
    }
}

private class MockTableViewDataSource: NSObject, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
