//
//  SandBrick.swift
//  Advent2023
//
//  Created by Mike Muszynski on 1/27/24.
//

import Foundation
import Coordinate
import SwiftUI

struct SandBrick: ExpressibleByStringLiteral, Equatable, Hashable {
    var start: Coordinate
    var end: Coordinate
    var color: Color? = nil
    
    var coordinates: Set<Coordinate> {
        if start.x == end.x && start.z == end.z {
            return Set(stride(from: start.y, through: end.y, by: 1).map { Coordinate(x: start.x, y: $0, z: start.z)})
        } else if start.x == end.x && start.y == end.y {
            return Set(stride(from: start.z, through: end.z, by: 1).map { Coordinate(x: start.x, y: start.y, z: $0)})
        } else if start.z == end.z && start.y == end.y {
            return Set(stride(from: start.x, through: end.x, by: 1).map { Coordinate(x: $0, y: start.y, z: start.z)})
        } else {
            return []
        }
    }
    
    var volume: Int {
        (abs(start.x - end.x) + 1) *
        (abs(start.y - end.y) + 1) *
        (abs(start.z - end.z) + 1)
    }
    
    var highestZ: Int {
        return max(start.z, end.z)
    }
    
    var lowestZ: Int {
        return min(start.z, end.z)
    }
    
    var isVertical: Bool {
        start.z != end.z
    }
    
    init(stringLiteral value: StringLiteralType) {
        self.init(string: String(value))
    }
    
    init(string: String) {
        //1,0,1~1,2,1
        let parts = string.components(separatedBy: "~")
        let start = Coordinate(stringLiteral: parts[0])
        let end = Coordinate(stringLiteral: parts[1])
        
        self.start = start
        self.end = end
    }
    
    mutating func move(down places: Int) {
        self.start.z -= places
        self.end.z -= places
    }
    
    func isFloating(in field: BrickField, ignoring coordinatesToIgnore: Set<Coordinate> = []) -> Bool {
        let coordinates = field.coordinateCache.subtracting(coordinatesToIgnore)
        
        //is this a vertical block?
        if self.isVertical {
            //yes. is there a brick directly below the lowest brick in this vertical?
            let bottom = min(start.z, end.z)
            if bottom == 1 { return false }
            
            return coordinates.first { coord in
                 coord == Coordinate(x: start.x, y: start.y, z: bottom - 1)
            } == nil
        } else {
            //no, so the z value of any coordinate is the same as the first and each needs to be checked
            if self.coordinates.first?.z == 1 { return false }
            let belowCoords = Set(self.coordinates.map { $0 - "0,0,1" })
            return coordinates.first { coord in
                belowCoords.contains(coord)
            } == nil
        }
    }
}

extension SandBrick: CustomDebugStringConvertible {
    var debugDescription: String {
        "\(start.x),\(start.y),\(start.z)~\(end.x),\(end.y),\(end.z)"
    }
}
