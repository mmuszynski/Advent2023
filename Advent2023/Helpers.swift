//
//  Helpers.swift
//  Advent2023
//
//  Created by Mike Muszynski on 12/6/23.
//

import Foundation

extension String {
    var separatedByLine: [String] {
        self.components(separatedBy: .newlines)
            .filter { $0 != "" }
    }
}

extension Array where Element: AdditiveArithmetic {
    public var sum: Element {
        self.reduce(0 as! Element, +)
    }
}

extension Array where Element: Numeric {
    public var product: Element {
        self.reduce(1 as! Element, *)
    }
}
