//
//  PipeSegment.swift
//  Advent2023
//
//  Created by Mike Muszynski on 12/12/23.
//

import Foundation

struct CoordinateEdge: OptionSet {
    typealias RawValue = Int
    var rawValue: RawValue
    init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    static let top = CoordinateEdge(rawValue: 1 << 0)
    static let bottom = CoordinateEdge(rawValue: 1 << 1)
    static let left = CoordinateEdge(rawValue: 1 << 2)
    static let right = CoordinateEdge(rawValue: 1 << 3)
    static let unknown = CoordinateEdge(rawValue: 1 << 4)
    
    static let vertical: CoordinateEdge = [.top, .bottom] //"|"
    static let horizontal: CoordinateEdge = [.left, .right] //"-"
    static let topRight: CoordinateEdge = [.top, .right] //"L"
    static let topLeft: CoordinateEdge = [.top, .left] //"J"
    static let bottomLeft: CoordinateEdge = [.bottom, .left] //"7"
    static let bottomRight: CoordinateEdge = [.bottom, .right] //"F"
    static let none: CoordinateEdge = [] //"."
    
    init(character: Character) {
        switch character {
        case "|":
            self = .vertical
        case "-":
            self = .horizontal
        case "L":
            self = .topRight
        case "J":
            self = .topLeft
        case "7":
            self = .bottomLeft
        case "F":
            self = .bottomRight
        case ".":
            self = .none
        case "S":
            self = .unknown
        default:
            fatalError()
        }
    }
    
    static let topExit: Coordinate = "0, -1"
    static let bottomExit: Coordinate = "0, 1"
    static let leftExit: Coordinate = "-1, 0"
    static let rightExit: Coordinate = "1, 0"
    
    init(coordinates: [Coordinate]) {
        self = .none
        if coordinates.contains(CoordinateEdge.topExit) {
            self.insert(.top)
        }
        if coordinates.contains(CoordinateEdge.bottomExit) {
            self.insert(.bottom)
        }
        if coordinates.contains(CoordinateEdge.leftExit) {
            self.insert(.left)
        }
        if coordinates.contains(CoordinateEdge.rightExit) {
            self.insert(.right)
        }
    }
    
    func nextPositions(from coordinate: Coordinate) -> [Coordinate] {
        var positions = [Coordinate]()
        if self.contains(.top) {
            positions.append(coordinate + CoordinateEdge.topExit)
        }
        if self.contains(.bottom) {
            positions.append(coordinate + CoordinateEdge.bottomExit)
        }
        if self.contains(.left) {
            positions.append(coordinate + CoordinateEdge.leftExit)
        }
        if self.contains(.right) {
            positions.append(coordinate + CoordinateEdge.rightExit)
        }
        return positions
    }
}

extension CoordinateEdge: CustomStringConvertible {
    var description: String {
        switch self {
        case .vertical:
            return "\u{2503}"
        case .horizontal:
            return "\u{2501}"
        case .topRight:
            return "\u{2517}"
        case .topLeft:
            return "\u{251B}"
        case .bottomLeft:
            return "\u{2513}"
        case .bottomRight:
            return "\u{250F}"
        case .none:
            return "."
        case .unknown:
            return "S"
        default:
            fatalError()
        }
    }
}

struct PipeMap {
    var pipes: [Coordinate : CoordinateEdge]
    var startingLocation: Coordinate?
    
    var rowCount: Int = 0
    var columnCount: Int = 0
    
    var orderedCoordinates: [Coordinate] = []
    
    init(string: String) {
        pipes = [:]
        
        for (row, line) in string.separatedByLine.enumerated() {
            for (col, char) in line.enumerated() {
                pipes[Coordinate(row: row, col: col)] = CoordinateEdge(character: char)
                columnCount = col + 1
            }
            rowCount = row + 1
        }
        
        if let unknown = pipes.first(where: { (key: Coordinate, value: CoordinateEdge) in
            value == .unknown
        }) {
            startingLocation = unknown.key
            pipes[unknown.key] = determineSegment(at: unknown.key)
        }
        
        orderedCoordinates =
            pipes.keys.sorted { one, two in
                if one.row == two.row { return one.col < two.col }
                return one.row < two.row
            }
    }
    
    func determineSegment(at coordinate: Coordinate) -> CoordinateEdge {
        //check all segments around
        let exits = [CoordinateEdge.topExit,
                     CoordinateEdge.leftExit,
                     CoordinateEdge.rightExit,
                     CoordinateEdge.bottomExit]
            .filter({ adjacent in
                let adjacent = adjacent + coordinate
                let adjacentPipe = pipes[adjacent]
                return adjacentPipe?.nextPositions(from: adjacent).contains(coordinate) == true
            })
        
        guard exits.count == 2 else { fatalError() }
        return CoordinateEdge(coordinates: exits)
    }
    
    func nextSegments(from coordinate: Coordinate) -> [Coordinate] {
        return pipes[coordinate].map { $0.nextPositions(from: coordinate) } ?? []
    }
    
    func findLoop(from newCoordinates: [Coordinate], existing: [Coordinate] = []) -> [Coordinate] {
        let next = newCoordinates.filter { !existing.suffix(2).contains($0) }
        if next.count > 0 {
            return findLoop(from: Array(next.map(nextSegments(from:)).joined()),
                            existing: existing + next)
        } else {
            return Array(Set(existing))
        }
    }
    
    func walkLoop(from start: Coordinate) -> [Coordinate] {
        var positions = [start]
        while positions.count == 1 || positions.last != start {
            let current = positions.last!
            let pipe = pipes[current]!
            
            if let next = pipe.nextPositions(from: current).filter({ !positions.suffix(2).contains($0) }).first {
                positions.append(next)
            }            
        }
        
        return positions
    }
    
    func line(_ row: Int, colStart: Int? = nil, colEnd: Int? = nil) -> String {
        var col = 0
        var accum = ""
        while let char = pipes[Coordinate(row: row, col: col)] {
            if (colStart ?? 0) <= col && (colEnd ?? .max) >= col {
                accum += char.description
            }
            col += 1
        }
        return accum
    }
    
}

extension PipeMap: CustomDebugStringConvertible {
    var debugDescription: String {
        var lines = [String]()
        for row in 0...(pipes.map(\.key.y).max() ?? 0) {
            lines.append(self.line(row))
        }
        return lines.joined(separator: "\n")
    }
}
