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

            it("has same amount of data as passed") {
                useCaseFactory.data = [
                    File(name: "A", path: "A", type: .regular),
                    File(name: "B", path: "B", type: .regular)
                ]

                sut.viewReady()

                expect(sut.numberOfFiles).to(equal(useCaseFactory.data.count))
            }

            it("calls refresh on view when view is ready") {
                sut.viewReady()
                expect(view.refreshCalled).to(beTrue())
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

private class DummyFileGateway: FileGateway {

    func contentsOfDirectory(path: String, completion: @escaping (Result<[File]>) -> Void) -> OperationHandle? {
        return nil
    }

    func contents(path: String, offset: Int64, length: Int, completion: @escaping (Result<Data>) -> Void) -> OperationHandle? {
        return nil
    }
}
