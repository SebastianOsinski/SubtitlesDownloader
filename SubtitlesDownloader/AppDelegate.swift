//
//  AppDelegate.swift
//  SubtitlesDownloader
//
//  Created by Sebastian Osiński on 22/01/2017.
//  Copyright © 2017 Sebastian Osinski. All rights reserved.
//

import UIKit
import FileProvider

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    private var webDavProvider: WebDAVFileProvider!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        return true
    }
}

enum Result<SuccessType> {
    case success(SuccessType)
    case failure(Error)
}

typealias ResultCallback<T> = (Result<T>) -> Void

struct FileEntity {

    enum EntityType {
        case file
        case directory
    }

    let name: String
    let path: String
    let type: EntityType
}

protocol OperationHandle {
    var progress: Float { get }

    func cancel()
}

protocol FileGateway {
    func contentsOfDirectory(path: String, completion: ResultCallback<[FileEntity]>) -> OperationHandle?
    func contents(path: String, offset: Int64, length: Int, completion: ResultCallback<Data>) -> OperationHandle?
}
