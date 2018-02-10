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

    func successes() -> Driver<Element.SuccessType> {
        return self
            .map { $0.success }
            .filter { $0 != nil }
            .map { $0! }
            .asDriver { error in
                return Driver.empty()
            }
    }
}
