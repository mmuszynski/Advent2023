//: [Previous](@previous)

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

CoordinateEdge.bottomRight.description
