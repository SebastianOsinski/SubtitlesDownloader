//
//  FilesListPresenterSpec.swift
//  SubtitlesDownloader
//
//  Created by Sebastian Osiński on 26/01/2017.
//  Copyright © 2017 Sebastian Osiński. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import SubtitlesDownloader

class FilesListPresenterSpec: QuickSpec {

    override func spec() {

        var sut: FilesListPresenter!
        var useCaseFactory: MockUseCaseFactory!
        var view: MockFilesListView!

        beforeEach {
            useCaseFactory = MockUseCaseFactory(fileGateway: DummyFileGateway())
            sut = FilesListPresenter(path: "", useCaseFactory: useCaseFactory)
            view = MockFilesListView()
            sut.view = view
        }

        describe("FilesListPresenter") {

            it("has no data in the beginning") {
                expect(sut.numberOfFiles).to(equal(0))
            }

            it("calls use case when view is ready") {
                sut.viewReady()
                expect(useCaseFactory.useCase.executeCalled).to(beTrue())
            }

            it("calls refresh on view when view is ready") {
                sut.viewReady()
                expect(view.refreshCalled).to(beTrue())
            }

            context("has data") {

                beforeEach {
                    useCaseFactory.data = [
                        File(name: "A", path: "A", type: .regular, size: 0),
                        File(name: "B", path: "B", type: .directory, size: 0)
                    ]

                    sut.viewReady()
                }

                it("has same amount of data as passed") {
                    expect(sut.numberOfFiles).to(equal(useCaseFactory.data.count))
                }

                it("calls showDirectory on view when selected file is directory and passes correct path") {
                    sut.cellSelected(at: 1)
                    expect(view.shownDirectoryPath).to(equal("B"))
                }

                it("doesn't call showDirectory on view when selected file is regular file") {
                    sut.cellSelected(at: 0)
                    expect(view.shownDirectoryPath).to(beNil())
                }

                it("sets up cell with correct name of file") {
                    let cell = MockFileCell()
                    sut.configureCell(cell, at: 0)

                    expect(cell.name).to(equal("A"))
                }
            }
        }
    }
}

private class MockFilesListView: FilesListViewProtocol {

    private(set) var refreshCalled = false
    private(set) var shownDirectoryPath: String?

    func refresh() {
        refreshCalled = true
    }

    func showDirectory(atPath path: String) {
        shownDirectoryPath = path
    }
}

private class MockFileCell: FileCellProtocol {

    private(set) var name: String?

    func displayName(_ name: String) {
        self.name = name
    }
}

private class MockUseCaseFactory: UseCaseFactory {

    var data = [File]()
    private(set) var useCase: MockShowFilesListUseCase!

    override func createUseCase(for use: Use) -> UseCase {
        switch use {
        case .showFiles(let path, let completion):
            useCase = MockShowFilesListUseCase(
                directoryPath: path,
                gateway: DummyFileGateway(),
                completion: completion
            )

            useCase.data = data

            return useCase
        default:
            fatalError()
        }
    }

}

private class MockShowFilesListUseCase: UseCase {

    private(set) var executeCalled = false

    private let directoryPath: String
    private let gateway: FileGateway
    private let completion: ShowFilesListCompletion

    var data = [File]()

    init(directoryPath: String, gateway: FileGateway, completion: @escaping ShowFilesListCompletion) {
        self.directoryPath = directoryPath
        self.gateway = gateway
        self.completion = completion
    }

    func execute() -> UseCaseHandle? {
        executeCalled = true
        completion(.success(data))
        return nil
    }

}
