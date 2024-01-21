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

func LCM(_ a: Int, _ b: Int) -> Int {
    abs(a * b) / GCD(a, b)
}

func GCD(_ a: Int, _ b: Int) -> Int {
    if a == 0 { return b }
    if b == 0 { return a }
    
    //A = B * Q + R
    return GCD(b, a % b)
}
