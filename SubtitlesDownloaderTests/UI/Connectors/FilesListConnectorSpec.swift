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

        describe("FilesListConnector") {

            var sut: FilesListConnector!
            var navigationController: UINavigationController!

            beforeEach {
                navigationController = UINavigationController()
                sut = FilesListConnector(
                    path: "",
                    fileGateway: DummyFileGateway(),
                    navigationController: navigationController
                )
            }

            it("does not push view controllers on navigation controller by default") {
                expect(navigationController.viewControllers).to(beEmpty())
            }

            it("returns FilesListViewController instance") {
                expect(sut.filesListViewController()).to(beAKindOf(FilesListViewController.self))
            }

            it("sets up relationships between view and presenter") {
                let viewController = sut.filesListViewController() as! FilesListViewController

                let presenter = viewController.presenter

                expect(presenter.view) === viewController
            }

            it("pushes controller on navigation controller after navigation to directory") {
                sut.navigateToDirectory(atPath: "")
                expect(navigationController.viewControllers).to(haveCount(1))
            }
        }
    }
}
