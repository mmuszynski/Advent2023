//
//  GalacticMap.swift
//  Advent2023
//
//  Created by Mike Muszynski on 12/12/23.
//

import Foundation

struct GalacticMap {
    enum GalacticContent: CustomDebugStringConvertible {
        case empty
        case galaxy
        case vastNothingness
        
        var debugDescription: String {
            switch self {
            case .empty:
                return "."
            case .galaxy:
                return "#"
            case .vastNothingness:
                return "@"
            }
        }
    }
    
    var map: Matrix2D<GalacticContent>
    var galaxies: [Coordinate] {
        map.coordinates(where: { content in
            content == .galaxy
        })
    }
    
    init(string: String) {
        map = Matrix2D(string: string) { line in
            line.map { char in
                switch char {
                case ".":
                    return .empty
                case "#":
                    return .galaxy
                default:
                    fatalError(String(char))
                }
            }
        }
    }
    
    func distance(from first: Coordinate, to second: Coordinate) -> Int {
        var first = first
        var accum = 0
        
        func value(from element: GalacticContent) -> Int {
            switch element {
            case .empty, .galaxy:
                return 1
            case .vastNothingness:
                return 10
            }
        }
        
        while first.x < second.x {
            first = first.advancing(x: 1, y: 0)
            accum += value(from: self.map.element(at: first))
        }
        
        while first.y < second.y {
            first = first.advancing(x: 0, y: 1)
            accum += value(from: self.map.element(at: first))
        }
        
        while second.x < first.x {
            first = first.advancing(x: -1, y: 0)
            accum += value(from: self.map.element(at: first))
        }
        
        while second.y < first.y {
            first = first.advancing(x: 0, y: -1)
            accum += value(from: self.map.element(at: first))
        }
        
        return accum
    }
    
}
