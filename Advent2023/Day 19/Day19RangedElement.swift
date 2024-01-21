//
//  Day19RangedElement.swift
//  Advent2023
//
//  Created by Mike Muszynski on 1/9/24.
//

import Foundation

struct Day19RangedElement: Equatable, Hashable {
    var x = 0..<4001
    var m = 0..<4001
    var a = 0..<4001
    var s = 0..<4001
    
    func clamped(to range: Range<Int>, on element: String) -> Self {
        var new = self
        switch element {
        case "x":
            new.x = new.x.clamped(to: range)
        case "m":
            new.m = new.m.clamped(to: range)
        case "a":
            new.a = new.a.clamped(to: range)
        case "s":
            new.s = new.s.clamped(to: range)
        default:
            new.x = new.x.clamped(to: range)
            new.m = new.m.clamped(to: range)
            new.a = new.a.clamped(to: range)
            new.s = new.s.clamped(to: range)
        }
        
        return new
    }
    
    var isEmpty: Bool {
        return [x, m, a, s].reduce(true) { partialResult, range in
            partialResult && range.isEmpty
        }
    }
    
    func isDistinct(from other: Day19RangedElement) -> Bool {
        self.x.clamped(to: other.x).isEmpty ||
        self.m.clamped(to: other.m).isEmpty ||
        self.a.clamped(to: other.a).isEmpty ||
        self.s.clamped(to: other.s).isEmpty
    }
}

struct Day19State {
    var element: Day19RangedElement
    var action: Day19Condition.Action
}
