//
//  Driver+Extensions.swift
//  SubtitlesDownloader
//
//  Created by Sebastian Osiński on 10.02.2018.
//  Copyright © 2018 Sebastian Osiński. All rights reserved.
//

import RxSwift
import RxCocoa

extension Driver where Element: ResultType {

    func successes() -> Driver<Element.Value> {
        return self
            .asObservable()
            .successes()
            .asDriverOnErrorJustComplete()
    }

    func errors() -> Driver<Element.Error> {
        return self
            .asObservable()
            .errors()
            .asDriverOnErrorJustComplete()
    }
}
