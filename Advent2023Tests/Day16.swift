//
//  Day6.swift
//  Advent2023Tests
//
//  Created by Mike Muszynski on 12/18/23.
//

import XCTest
@testable import Advent2023
import BundleURL

enum Direction: Coordinate {
    case up = "0,-1"
    case right = "1,0"
    case down = "0,1"
    case left = "-1,0"
    
    var opposite: Direction {
        Direction(rawValue: self.rawValue.flipped)!
    }
}

extension Coordinate {
    func nextCoordinateIn(direction: Direction) -> Coordinate {
        self + direction.rawValue
    }
}

enum MirrorType: Character {
    case empty = "."
    case reflectorBackslash = "\\"
    case reflectorSlash = "/"
    case splitterHorizontal = "-"
    case splitterVertical = "|"
    
    func nextDirectionsMoving(_ previousDirection: Direction) -> [Direction] {
        switch self {
        case .empty:
            return [previousDirection]
        case .reflectorBackslash:
            switch previousDirection {
            case .up:
                return [.left]
            case .down:
                return [.right]
            case .left:
                return [.up]
            case .right:
                return [.down]
            }
        case .reflectorSlash:
            switch previousDirection {
            case .up:
                return [.right]
            case .right:
                return [.up]
            case .down:
                return [.left]
            case .left:
                return [.down]
            }
        case .splitterHorizontal:
            switch previousDirection {
            case .up, .down:
                return [.left, .right]
            case .left, .right:
                return [previousDirection]
            }
        case .splitterVertical:
            switch previousDirection {
            case .up, .down:
                return [previousDirection]
            case .left, .right:
                return [.up, .down]
            }
        }
    }
}

final class Day16: XCTestCase {
    
    let input = #bundleURL("inputDay16")!
    let example = #bundleURL("exampleDay16")!
    
    struct LightPulse: Hashable {
        var coordinate: Coordinate
        var direction: Direction
        
        init(_ coordinate: Coordinate, _ direction: Direction) {
            self.coordinate = coordinate
            self.direction = direction
        }
    }
    
    var history: Set<LightPulse> = []
    
    override func setUp() async throws {
        history.removeAll()
        history.insert(.init(Coordinate(x: 0, y: 0), .right))
    }
    
    func process(_ lightPulses: [LightPulse], in mirrors: Matrix2D<MirrorType>) -> [LightPulse] {
        if lightPulses.isEmpty { return [] }
        
        print(lightPulses)
        
        var pulses = lightPulses
        var outputPulses: [LightPulse] = []
        while let pulse = pulses.popLast() {
            let position = pulse.coordinate + pulse.direction.rawValue
            
            guard   (0..<mirrors.rowCount).contains(position.row) &&
                    (0..<mirrors.columnCount).contains(position.col)
            else {
                continue
            }
            
            let mirror = mirrors.element(at: position)
            let newPulses = mirror.nextDirectionsMoving(pulse.direction).map { direction in
                LightPulse(position, direction)
            }
            
            outputPulses.append(contentsOf: newPulses.filter { !history.contains($0) })
        }
        
        history.formUnion(outputPulses)
        return process(outputPulses, in: mirrors)
    }
    
    func testTrivial() throws {
        let string = """
        ...
        ...
        ...
        """
        
        let mirrorMatrix =  Matrix2D(string: string) { line in
            line.compactMap(MirrorType.init)
        }
        
        let lightPulses: [LightPulse] = [.init(Coordinate(row: 0, col: 0), Direction.right)]
        let _ = process(lightPulses, in: mirrorMatrix)
        XCTAssertEqual(history.count, 3)
    }
    
    func testTrivialBackslash() throws {
        let string = """
        ..\\
        ...
        ...
        """
        
        let mirrorMatrix =  Matrix2D(string: string) { line in
            line.compactMap(MirrorType.init)
        }
        
        let lightPulses: [LightPulse] = [.init(Coordinate(row: 0, col: 0), Direction.right)]
        let _ = process(lightPulses, in: mirrorMatrix)
        XCTAssertEqual(history.count, 5)
    }
    
    func testTrivialSplitter() throws {
        let string = """
        .|.
        ...
        ...
        """
        
        let mirrorMatrix =  Matrix2D(string: string) { line in
            line.compactMap(MirrorType.init)
        }
        
        let lightPulses: [LightPulse] = [.init(Coordinate(row: 0, col: 0), Direction.right)]
        let _ = process(lightPulses, in: mirrorMatrix)
        XCTAssertEqual(Set(history.map(\.coordinate)).count, 4)
    }
    
    func testLessTrivialSplitter() throws {
        let string = """
        .|.
        .-.
        ...
        """
        
        let mirrorMatrix =  Matrix2D(string: string) { line in
            line.compactMap(MirrorType.init)
        }
        
        let lightPulses: [LightPulse] = [.init(Coordinate(row: 0, col: 0), Direction.right)]
        let _ = process(lightPulses, in: mirrorMatrix)
        XCTAssertEqual(Set(history.map(\.coordinate)).count, 5)
    }
    
    func testTrivialLoop() throws {
        let string = """
        -..\\
        ....
        ....
        \\../
        """
        
        let mirrorMatrix =  Matrix2D(string: string) { line in
            line.compactMap(MirrorType.init)
        }
        
        let lightPulses: [LightPulse] = [.init(Coordinate(row: 0, col: 0), Direction.right)]
        let _ = process(lightPulses, in: mirrorMatrix)
        XCTAssertEqual(Set(history.map(\.coordinate)).count, 12)
    }
    
    func testExampleDay16() throws {
        let string = try String(contentsOf: example)
        let mirrorMatrix = Matrix2D(string: string) { line in
            line.compactMap(MirrorType.init)
        }
        
        var lightPulses: [LightPulse] = [.init(Coordinate(row: 0, col: 0), Direction.right)]
        lightPulses = process(lightPulses, in: mirrorMatrix)
        
        XCTAssertEqual(Set(history.map(\.coordinate)).count, 46)
    }
    
    func testInputDay16() throws {
        let string = try String(contentsOf: input)
        let mirrorMatrix = Matrix2D(string: string) { line in
            line.compactMap(MirrorType.init)
        }
        
        var lightPulses: [LightPulse] = [.init(Coordinate(row: 0, col: 0), Direction.right)]
        lightPulses = process(lightPulses, in: mirrorMatrix)
        
        XCTAssertEqual(history.count, 46)
    }
}
