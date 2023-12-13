//
//  Coordinate.swift
//  Advent2023
//
//  Created by Mike Muszynski on 12/12/23.
//

import Foundation

public struct Coordinate: Hashable, ExpressibleByStringLiteral {
    public var x: Int
    public var y: Int
    
    public var row: Int {
        get {
            return y
        }
        set {
            y = newValue
        }
    }
    
    public var col: Int {
        get {
            return x
        }
        set {
            x = newValue
        }
    }
    
    public init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
    
    public init(row: Int, col: Int) {
        self.init(x: col, y: row)
    }
    
    public init(stringLiteral value: StringLiteralType) {
        let values = value
            .components(separatedBy: .whitespaces)
            .joined()
            .components(separatedBy: ",")
            .compactMap { Int($0) }
        self.init(x: values[0],
                  y: values[1])
    }
    
    public func advancing(x: Int, y: Int) -> Coordinate {
        Coordinate(x: self.x + x, y: self.y + y)
    }
    
    func distance(from other: Coordinate) -> Int {
        return abs(other.x - self.x) + abs(other.y - self.y)
    }
}

extension Coordinate: AdditiveArithmetic {
    public static var zero: Coordinate {
        Coordinate(x: 0, y: 0)
    }
    
    public static func + (lhs: Coordinate, rhs: Coordinate) -> Coordinate {
        Coordinate(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    
    public static func - (lhs: Coordinate, rhs: Coordinate) -> Coordinate {
        Coordinate(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
}
