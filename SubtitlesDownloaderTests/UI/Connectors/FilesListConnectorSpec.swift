//
//  FilesListConnectorSpec.swift
//  SubtitlesDownloader
//
//  Created by Sebastian Osiński on 26/01/2017.
//  Copyright © 2017 Sebastian Osiński. All rights reserved.
//

import Quick
import Nimble
@testable import SubtitlesDownloader

class FilesListConnectorSpec: QuickSpec {

    override func spec() {

        describe("FileListConnector") {

            var sut: FileListConnector!
            var navigationController: UINavigationController!

            beforeEach {
                navigationController = UINavigationController()
                sut = FileListConnector(
                    path: "",
                    fileGateway: DummyFileGateway(),
                    navigationController: navigationController
                )
            }

            it("does not push view controllers on navigation controller by default") {
                expect(navigationController.viewControllers).to(beEmpty())
            }

            it("returns FileListViewController instance") {
                expect(sut.fileListViewController()).to(beAKindOf(FileListViewController.self))
            }

            it("pushes controller on navigation controller after navigation to directory") {
                sut.navigateToDirectory(atPath: "")
                expect(navigationController.viewControllers).to(haveCount(1))
            }
        }
    }
}
