//
//  Day10.swift
//  Advent2023Tests
//
//  Created by Mike Muszynski on 12/11/23.
//

import XCTest
import BundleURL
@testable import Advent2023

final class Day10: XCTestCase {
    
    let input = #bundleURL("inputDay10")!
    let example = #bundleURL("exampleDay10")!
    
    func testExampleDay10() throws {
        let string = try String(contentsOf: example)
        let map = PipeMap(string: string)
        
        XCTAssertEqual(map.determineSegment(at: "1,1"), [.bottom, .right])
        XCTAssertNil(map.pipes.map(\.value).firstIndex(of: .unknown))
        
        XCTAssertEqual(map.walkLoop(from: "1,1").count / 2, 4)
        
        let complex = try String(contentsOf: #bundleURL("complexExample10")!)
        let complexMap = PipeMap(string: complex)
        XCTAssertEqual(complexMap.walkLoop(from: "2,0").count / 2, 8)
    }
    
    func testInputDay10() throws {
        let string = try String(contentsOf: input)
        let map = PipeMap(string: string)
        
        //XCTAssertEqual(map.findLoop(from: [map.startingLocation!]).count, 6890)
        XCTAssertEqual(map.walkLoop(from: map.startingLocation!).count / 2, 6890)
    }
    
    func testInputDay10Part2() throws {
        let string = try String(contentsOf: input)
        var map = PipeMap(string: string)
        var openingMap: [Coordinate : OpeningType] = [:]

        let loop = map.walkLoop(from: map.startingLocation!)
        
        loop.forEach { coord in
            openingMap[coord] = .pipe
        }
        
        let loopSet = Set(loop)
        
        enum OpeningType {
            case pipe
            case open
            case enclosed
        }
        
        let rows = map.pipes.keys.max(by: { $0.y < $1.y })?.y ?? 0
        let cols = map.pipes.keys.max(by: { $0.x < $1.x })?.x ?? 0

        var inside = 0
        for row in 0...rows {
            var topWinding = 0
            var bottomWinding = 0
            
            var rowChars = [Character]()
            for col in 0...cols {
                let coord = Coordinate(row: row, col: col)
                if loopSet.contains(coord), let pipe = map.pipes[coord] {
                    rowChars.append(contentsOf: pipe.description)
                    if pipe.contains(.top) { topWinding += 1 }
                    if pipe.contains(.bottom) { bottomWinding += 1 }
                    
                    
                } else {
                    rowChars.append("X")
                }
                
                if topWinding % 2 == 1 && bottomWinding % 2 == 1 {
                    if !loopSet.contains(coord) {
                        //print(coord)
                        inside += 1
                    }
                }
                //rowChars.append(openingMap[Coordinate(row: row, col: col)] == .pipe ? "X" : ".")
            }
            print(rowChars.map(String.init).joined())
            //print(map.line(row))
        }
        
        XCTAssertEqual(inside, 453)
    }
    
}
