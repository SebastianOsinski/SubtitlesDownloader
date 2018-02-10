//
//  Observable+Extensions.swift
//  SubtitlesDownloader
//
//  Created by Sebastian Osiński on 10.02.2018.
//  Copyright © 2018 Sebastian Osiński. All rights reserved.
//

import RxSwift
import RxSwiftExt

extension Observable where Element: ResultType {

    func successes() -> Observable<Element.Value> {
        return self.map { $0.success }.unwrap()
    }

    func errors() -> Observable<Element.Error> {
        return self.map { $0.error }.unwrap()
    }
}
