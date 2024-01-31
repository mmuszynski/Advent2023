//
//  Helpers.swift
//  Advent2023
//
//  Created by Mike Muszynski on 12/6/23.
//

import Foundation
import SwiftUI

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

extension Array where Element == Bool {
    var any: Bool {
        self.reduce(false) { $0 || $1 }
    }
    
    var all: Bool {
        self.reduce(true) { $0 && $1 }
    }
}

extension Color {
    static var random: Color {
        Color(hue: .random(in: 0...1), saturation: .random(in: 0...1), brightness: .random(in: 0...1))
    }
}
