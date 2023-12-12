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
    
    private var topExit: Coordinate = "0, -1"
    private var bottomExit: Coordinate = "0, 1"
    private var leftExit: Coordinate = "-1, 0"
    private var rightExit: Coordinate = "1, 0"
    
    func nextPositions(from coordinate: Coordinate) -> [Coordinate] {
        var positions = [Coordinate]()
        if self.contains(.top) {
            positions.append(coordinate + topExit)
        }
        if self.contains(.bottom) {
            positions.append(coordinate + bottomExit)
        }
        if self.contains(.left) {
            positions.append(coordinate + leftExit)
        }
        if self.contains(.right) {
            positions.append(coordinate + rightExit)
        }
        return positions
    }
}

extension CoordinateEdge: CustomStringConvertible {
    var description: String {
        switch self {
        case .vertical:
            return "|"
        case .horizontal: 
            return "-"
        case .topRight:
            return "L"
        case .topLeft:
            return "J"
        case .bottomLeft: 
            return "7"
        case .bottomRight:
            return "F"
        case .none:
            return "."
        case .unknown:
            return "S"
        default:
            fatalError()
        }
    }
}

enum PipeSegment: Character {
    case vertical = "|"
    case horizontal = "-"
    case topRight = "L"
    case topLeft = "J"
    case bottomLeft = "7"
    case bottomRight = "F"
    case none = "."
    case unknown = "S"
    
    func nextPositions(from coordinate: Coordinate) -> [Coordinate] {
        switch self {
        case .vertical:
            return [coordinate + Coordinate(x: 0, y: 1),
                    coordinate + Coordinate(x: 0, y: -1)]
        case .horizontal:
            return [coordinate + Coordinate(x: 1, y: 0),
                    coordinate + Coordinate(x: -1, y: 0)]
        case .topRight:
            return [coordinate + Coordinate(x: 1, y: 1),
                    coordinate + Coordinate(x: -1, y: -1)]
        case .topLeft:
            return [coordinate + Coordinate(x: -1, y: 1),
                    coordinate + Coordinate(x: 1, y: -1)]
        case .bottomLeft:
            return [coordinate + Coordinate(x: -1, y: -1),
                    coordinate + Coordinate(x: 1, y: 1)]
        case .bottomRight:
            return [coordinate + Coordinate(x: 1, y: -1),
                    coordinate + Coordinate(x: -1, y: 1)]
        case .none:
            fatalError("Shouldn't be able to get to this position")
        case .unknown:
            fatalError("Can't get position from unknown")
        }
    }
}

struct PipeMap {
    var pipes: [Coordinate : CoordinateEdge]
    
    init(string: String) {
        pipes = [:]
        for (row, line) in string.separatedByLine.enumerated() {
            for (col, char) in line.enumerated() {
                pipes[Coordinate(row: row, col: col)] = CoordinateEdge(character: char)
            }
        }
    }
    
    func determineSegment(at coordinate: Coordinate) -> PipeSegment {
        //check all segments around
        let exits = ["0, -1", "-1, 0", "1, 0", "0, 1"]
            .map(Coordinate.init)
            .filter({ adjacent in
                let adjacentPipe = pipes[adjacent + coordinate]
                return adjacentPipe?.nextPositions(from: coordinate).contains(coordinate) == true
            })

        guard exits.count == 2 else { fatalError() }
        fatalError()
    }
    
    func findLoop(starting: Coordinate) -> [Coordinate] {
        var totalLoop = [starting]
        
        while totalLoop.count < 1 && totalLoop.first != totalLoop.last {
            guard let current = totalLoop.last else { fatalError() }
            let segment = pipes[current]
        }
        
        return totalLoop.dropLast()
    }
    
    
    fileprivate func line(_ row: Int) -> String {
        var col = 0
        var accum = ""
        while let char = pipes[Coordinate(row: row, col: col)] {
            col += 1
            accum += char.description
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
