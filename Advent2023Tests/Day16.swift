//
//  Day6.swift
//  Advent2023Tests
//
//  Created by Mike Muszynski on 12/18/23.
//

import XCTest
@testable import Advent2023
import BundleURL

final class Day16: XCTestCase {
    
    let input = #bundleURL("inputDay16")!
    let example = #bundleURL("exampleDay16")!
    
    var history: Set<LightPulse> = []
    
    override func setUp() async throws {
        history.removeAll()
        history.insert(.init(Coordinate(x: 0, y: 0), .right))
    }
    
    func process(_ lightPulses: [LightPulse], in mirrors: Matrix2D<ReflectorType>) -> [LightPulse] {
        if lightPulses.isEmpty { return [] }
        
        print(lightPulses)
        
        var pulses = lightPulses
        var outputPulses: [LightPulse] = []
        while let pulse = pulses.popLast() {
            let position = pulse.coordinate + pulse.direction
            
            guard let mirror = mirrors.element(at: position) else { continue }
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
            line.compactMap(ReflectorType.init)
        }
        
        let lightPulses: [LightPulse] = [.init(Coordinate(row: 0, col: 0), .right)]
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
            line.compactMap(ReflectorType.init)
        }
        
        let lightPulses: [LightPulse] = [.init(Coordinate(row: 0, col: 0), .right)]
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
            line.compactMap(ReflectorType.init)
        }
        
        let lightPulses: [LightPulse] = [.init(Coordinate(row: 0, col: 0), .right)]
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
            line.compactMap(ReflectorType.init)
        }
        
        let lightPulses: [LightPulse] = [.init(Coordinate(row: 0, col: 0), .right)]
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
            line.compactMap(ReflectorType.init)
        }
        
        let lightPulses: [LightPulse] = [.init(Coordinate(row: 0, col: 0), .right)]
        let _ = process(lightPulses, in: mirrorMatrix)
        XCTAssertEqual(Set(history.map(\.coordinate)).count, 12)
    }
    
    func testExampleDay16() throws {
        let string = try String(contentsOf: example)
        let mirrorMatrix = Matrix2D(string: string) { line in
            line.compactMap(ReflectorType.init)
        }
        
        var lightPulses: [LightPulse] = [.init(Coordinate(row: 0, col: 0), .right)]
        lightPulses = process(lightPulses, in: mirrorMatrix)
        
        XCTAssertEqual(Set(history.map(\.coordinate)).count, 46)
    }
    
    func testInputDay16() throws {
        let controller = ReflectorMapController(url: input)
        controller.reset(starting: LightPulse(Coordinate(row: 0, col: -1), .right))
        controller.solve()
        
        XCTAssertEqual(Set(controller.history.reduce([],+).map(\.coordinate).filter({ $0.x >= 0 && $0.y >= 0 })).count, 7034)
    }
    
    func testInputDay16Part2() throws {
        let controller = ReflectorMapController(url: input)
        controller.solvePartTwo()
        
        XCTAssertEqual(controller.best, 7759)
    }
}
