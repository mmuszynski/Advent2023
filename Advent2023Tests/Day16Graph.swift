//
//  Day6.swift
//  Advent2023Tests
//
//  Created by Mike Muszynski on 12/18/23.
//

import XCTest
@testable import Advent2023
import BundleURL
import Graph
import Coordinate

/*
 .|...\....
 |.-.\.....
 .....|-...
 ........|.
 ..........
 .........\
 ..../.\\..
 .-.-/..|..
 .|....-|.\
 ..//.|....
 */

final class Day16Graph: XCTestCase {
    
    let input = #bundleURL("inputDay16")!
    let example = #bundleURL("exampleDay16")!
    
    func testNextElement() throws {
        let string = try String(contentsOf: example)
        let controller = ReflectorGraphController(string: string)
        
        XCTAssertEqual(controller.nextElement(from: "0,0", moving: .right), Reflector(type: .init(rawValue: "|")!, location: "1,0"))
        XCTAssertEqual(controller.nextElement(from: "9,0", moving: .down), Reflector(type: .init(rawValue: "\\")!, location: "9,5"))
    }
    
    func testCycles() throws {
        let string = """
        -..\\
        ....
        ....
        \\../
        """
        let start = LightPulse(moving: .right, location: "-1,0")
        let controller = ReflectorGraphController(string: string)
        let neighbors = controller.graph.neighbors(of: start)
        let neighbors2 = Array(neighbors.map { controller.graph.neighbors(of: $0) }.joined())
        let neighbors3 = Array(neighbors2.map { controller.graph.neighbors(of: $0) }.joined())
        let neighbors4 = Array(neighbors3.map { controller.graph.neighbors(of: $0) }.joined())
        let neighbors5 = Array(neighbors4.map { controller.graph.neighbors(of: $0) }.joined())
        printState(map: string, pulses: neighbors5)
        
        controller.nextStates(from: start).forEach { state in
            controller.graph.addEdge(from: start, to: state)
        }
        let directionField = controller.graph.directionField(start: start)
        var coords: Set<Coordinate> = coordinates(from: directionField)
        XCTAssertEqual(coords.count, 12)
    }
    
    func testBackEdges() throws {
        let string = """
        -|..\\
        .-../
        .....
        \\.../
        """
        let start = LightPulse(moving: .right, location: "-1,0")
        let controller = ReflectorGraphController(string: string)
        let neighbors = controller.graph.neighbors(of: start)
        let neighbors2 = Array(neighbors.map { controller.graph.neighbors(of: $0) }.joined())
        let neighbors3 = Array(neighbors2.map { controller.graph.neighbors(of: $0) }.joined())
        let neighbors4 = Array(neighbors3.map { controller.graph.neighbors(of: $0) }.joined())
        let neighbors5 = Array(neighbors4.map { controller.graph.neighbors(of: $0) }.joined())
        printState(map: string, pulses: neighbors5)
        
        controller.nextStates(from: start).forEach { state in
            controller.graph.addEdge(from: start, to: state)
        }
        let directionField = controller.graph.directionFieldWithBackEdges(start: start)
        var coords: Set<Coordinate> = coordinates(from: directionField)
        XCTAssertEqual(coords.count, 10)
    }
    
    func coordinates(from directionField: [LightPulse: LightPulse]) -> Set<Coordinate> {
        return coordinates(from: directionField.map { ($0.key, $0.value) })
    }
    
    func coordinates(from directionField: [(LightPulse, LightPulse)]) -> Set<Coordinate> {
        var coords: Set<Coordinate> = []
        for (key, value) in directionField {
            if key.coordinate.x < value.coordinate.x {
                let y = key.coordinate.y
                for x in key.coordinate.x...value.coordinate.x {
                    coords.insert(Coordinate(x: x, y: y))
                }
            } else if value.coordinate.x < key.coordinate.x {
                let y = key.coordinate.y
                for x in value.coordinate.x...key.coordinate.x {
                    coords.insert(Coordinate(x: x, y: y))
                }
            } else if key.coordinate.y < value.coordinate.y {
                let x = key.coordinate.x
                for y in key.coordinate.y...value.coordinate.y {
                    coords.insert(Coordinate(x: x, y: y))
                }
            } else if value.coordinate.y < key.coordinate.y {
                let x = key.coordinate.x
                for y in value.coordinate.y...key.coordinate.y {
                    coords.insert(Coordinate(x: x, y: y))
                }
            }
        }
        coords = coords.filter { $0.x >= 0 && $0.y >= 0 }
        return coords
    }
    
    func printState(map: String, pulses: [LightPulse] = []) {
        var state = ""
        for (row, line) in map.separatedByLine.enumerated() {
            var rowString = ""
            for (col, element) in line.enumerated() {
                if let pulse = pulses.first(where: { $0.location == Coordinate(row: row, col: col) }) {
                    switch pulse.moving {
                    case .left:
                        rowString.append("<")
                    case .right:
                        rowString.append(">")
                    case .up:
                        rowString.append("^")
                    case .down:
                        rowString.append("v")
                    default:
                        rowString.append("*")
                    }
                } else {
                    rowString.append(element)
                }
            }
            state.append(rowString + "\r")
        }
        print(state)
    }
    
    func testManualGraph() throws {
        let string = """
        -..\\
        ....
        ....
        \\../
        """
        
        let controller = ReflectorGraphController(string: string)
        controller.graph.addEdge(from: LightPulse(moving: .right, location: "-1,0"), to: LightPulse(moving: .right, location: "0,0"))
        
        var graph = DirectionalGraph<LightPulse>()
        graph.addEdge(from: LightPulse(moving: .right, location: "-1,0"),
                      to:   LightPulse(moving: .right, location: "0,0"))
        graph.addEdge(from: LightPulse(moving: .right, location: "0,0"),
                      to:   LightPulse(moving: .down, location: "3,0"))
        graph.addEdge(from: LightPulse(moving: .down, location: "3,0"),
                      to:   LightPulse(moving: .left, location: "3,3"))
        graph.addEdge(from: LightPulse(moving: .left, location: "3,3"),
                      to:   LightPulse(moving: .up, location: "0,3"))
        graph.addEdge(from: LightPulse(moving: .up, location: "0,3"),
                      to:   LightPulse(moving: .right, location: "0,0"))
        graph.addEdge(from: LightPulse(moving: .up, location: "0,3"),
                      to:   LightPulse(moving: .left, location: "0,0"))
        graph.addEdge(from: LightPulse(moving: .up, location: "0,3"),
                      to:   LightPulse(moving: .left, location: "0,0"))
        print(graph.floodFill(start: LightPulse(moving: .right, location: "-1,0")))
                
        for edge in graph.edges {
            XCTAssertTrue(controller.graph.edges.contains(edge))
        }
    }
    
    func testReflectorSort() throws {
        let initial = [Reflector(type: .empty, location: "0,1"),
                       Reflector(type: .empty, location: "0,2")]
        XCTAssertEqual(initial, initial.sorted(by: Reflector.rowAscending))
        XCTAssertEqual(initial, Array(initial.sorted(by: Reflector.rowDescending(_:_:)).reversed()))
    }
    
    func testExamplePart1() throws {
        let string = try String(contentsOf: example)
        let controller = ReflectorGraphController(string: string)
        let start = LightPulse(moving: .right, location: "-1,0")
        controller.nextStates(from: start).forEach { nextPulse in
            controller.graph.addEdge(from: start, to: nextPulse)
        }
        
        let directionField = controller.graph.directionFieldWithBackEdges(start: start)
        let coords = coordinates(from: directionField)
        XCTAssertEqual(coords.count, 46)
    }
    
    func testInputPart1() throws {
        let time = try ContinuousClock().measure {
            let string = try String(contentsOf: input)
            let controller = ReflectorGraphController(string: string)
            let start = LightPulse(moving: .right, location: "-1,0")
            controller.nextStates(from: start).forEach { nextPulse in
                controller.graph.addEdge(from: start, to: nextPulse)
            }
                
            let directionField = controller.graph.directionFieldWithBackEdges(start: start)
            let coords = coordinates(from: directionField)
            XCTAssertEqual(coords.count, 7034)
        }
        print(time)
    }
    
    func testInputPart2() throws {
        let string = try String(contentsOf: input)
        let controller = ReflectorGraphController(string: string)
        let potentialStarts = controller.graph.nodeLookup.filter { (_, value) in
            let coordinate = value.coordinate
            return coordinate.row < 0 || coordinate.col < 0 || coordinate.col >= controller.columnCount || coordinate.row >= controller.rowCount
        }.map(\.value)
        let reversed = potentialStarts.map { $0.reversed }
        
        var value = 0
        for start in reversed {
            controller.nextStates(from: start).forEach { nextPulse in
                controller.graph.addEdge(from: start, to: nextPulse)
            }
            let directionField = controller.graph.directionFieldWithBackEdges(start: start)
            let set = coordinates(from: directionField)
            value = max(set.count, value)
        }
                
        //let directionField = controller.graph.directionFieldWithBackEdges(start: start)
        //let coords = coordinates(from: directionField)
        XCTAssertEqual(value, 7759)
    }
}
