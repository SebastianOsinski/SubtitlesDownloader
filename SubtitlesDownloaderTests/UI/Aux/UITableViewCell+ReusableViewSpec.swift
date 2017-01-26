//
// Created by Sebastian Osiński on 26/01/2017.
// Copyright (c) 2017 Sebastian Osiński. All rights reserved.
//

import Quick
import Nimble
@testable import SubtitlesDownloader

class UITableViewCellReusableViewSpec: QuickSpec {

    override func spec() {

        describe("UITableViewCell+ReusableView") {

            it("UITableViewCell has correct default reuse identifier") {
                expect(UITableViewCell.self.defaultReuseIdentifier).to(equal("UITableViewCell"))
            }

            it("UITableViewCell's subclass has correct default reuse identifier") {
                expect(TestTableViewCell.self.defaultReuseIdentifier).to(equal("TestTableViewCell"))
            }
        }
    }
}

class TestTableViewCell: UITableViewCell { }
