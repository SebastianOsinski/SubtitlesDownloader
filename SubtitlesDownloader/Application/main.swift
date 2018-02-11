//
//  main.swift
//  SubtitlesDownloader
//
//  Created by Sebastian Osiński on 11.02.2018.
//  Copyright © 2018 Sebastian Osiński. All rights reserved.
//

import UIKit

private let argc = CommandLine.argc
private let argv = UnsafeMutableRawPointer(CommandLine.unsafeArgv).bindMemory(
    to: UnsafeMutablePointer<Int8>.self,
    capacity: Int(CommandLine.argc)
)

#if DEBUG
private class UnitTestAppDelegate: UIResponder, UIApplicationDelegate {}

private let isRunningUnitTests = NSClassFromString("XCTestCase") != nil
private let appDelegateClassName: String

if isRunningUnitTests {
    appDelegateClassName = NSStringFromClass(UnitTestAppDelegate.self)
} else {
    appDelegateClassName = NSStringFromClass(AppDelegate.self)
}

UIApplicationMain(argc, argv, nil, appDelegateClassName)
#else
UIApplicationMain(argc, argv, nil, NSStringFromClass(AppDelegate.self))
#endif
