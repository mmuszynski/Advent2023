//
//  Day13.swift
//  Advent2023Tests
//
//  Created by Mike Muszynski on 12/16/23.
//

import XCTest
import BundleURL
@testable import Advent2023

final class Day14: XCTestCase {
    
    let input = #bundleURL("inputDay14")!
    let example = #bundleURL("exampleDay14")!
    let examplePacked = #bundleURL("exampleDay14Packed")!
    
    func pack(string: String, ascending: Bool = true) -> String {
        let output = string
            .components(separatedBy: "#")
            .map {
                var sorted = $0.sorted()
                if ascending { sorted = sorted.reversed() }
                
                return sorted
                    .map(String.init)
                    .joined()
            }.map {
                $0.isEmpty ? "#" : "\($0)#" }
            .joined()
            .dropLast()
        
        return String(output)
    }
    
    func packColumn(_ column: MatrixColumn<String>, ascending: Bool = true) -> MatrixColumn<String> {
        let string = column.map { $0 }.joined()
        let output = pack(string: string, ascending: ascending)
        
        return MatrixColumn(elements: output.map { String($0) })
    }
    
    func packRow(_ row: MatrixRow<String>, ascending: Bool = true) -> MatrixRow<String> {
        let string = row.map { $0 }.joined()
        let output = pack(string: string, ascending: ascending)
        
        return MatrixRow(output.map { String($0) })
    }
    
    func testPackColumn() throws {
        let column = MatrixColumn(elements: "OO.O.O..##".map { String($0) })
        let packed = MatrixColumn(elements: "OOOO....##".map { String($0) })
        
        XCTAssertNotEqual(column, packed)
        XCTAssertEqual(packColumn(column), packed)
        
        XCTAssertEqual(scoreColumn(packColumn(column), against: "O"), 34)
        
        
        let harderColumn = MatrixColumn(elements: "OO.O#..OO.#O..O..".map { String($0) })
        let harderColumnPacked = MatrixColumn(elements: "OOO.#OO...#OO....".map { String($0) })
        
        XCTAssertNotEqual(harderColumn, harderColumnPacked)
        XCTAssertEqual(packColumn(harderColumn), harderColumnPacked)
        
        let reversePacked = MatrixColumn(elements: "....OOOO##".map { String($0) })
        XCTAssertEqual(packColumn(column, ascending: false), reversePacked)
        
        let harderColumnReversePacked = MatrixColumn(elements: ".OOO#...OO#....OO".map { String($0) })
        XCTAssertEqual(packColumn(harderColumn, ascending: false), harderColumnReversePacked)
    }
    
    func scoreColumn<S: Equatable>(_ column: MatrixColumn<S>, against element: S) -> Int {
        let max = column.count
        var count = 0
        for i in 0..<max {
            if column[i] == element {
                count += (max - i)
            }
        }
        return count
    }
    
    func testExamplePacking() throws {
        let string = try String(contentsOf: example)
        let maps = string.components(separatedBy: "\n\n")
            .map { Matrix2D(string: $0) { line in
                line.map(String.init)
            }}
        
        
        let stringPacked = try String(contentsOf: examplePacked)
        let mapsPacked = stringPacked.components(separatedBy: "\n\n")
            .map { Matrix2D(string: $0) { line in
                line.map(String.init)
            }}
        
        print(mapsPacked[0])
        
        var map = maps[0]
        packMap(&map, inDirection: 0)
        
        XCTAssertEqual(map, mapsPacked[0])
        
        var score = 0
        for map in maps {
            var map = map
            packMap(&map, inDirection: 0)
            score += computeSumFor(map: map)
        }
        
        XCTAssertEqual(score, 136)
    }
    
    func computeSumFor(map: Matrix2D<String>) -> Int {
        map.enumerated().map { (offset, element) in
            var matches = element
            matches.removeAll(where: { $0 != "O" })
            return matches.count * (map.rowCount - offset)
        }.sum
    }
    
    func testComputeSum() throws {
        let string = """
        .....#....
        ....#...O#
        .....##...
        ..O#......
        .....OOO#.
        .O#...O#.#
        ....O#...O
        .......OOO
        #...O###.O
        #.OOO#...O
        """
        let map = Matrix2D(string: string) { line in
            line.map(String.init)
        }
    
        XCTAssertEqual(computeSumFor(map: map), 4 + 2 * 2 + 3 * 3 + 2 * 4 + 2 * 5 + 3 * 6 + 7 + 9)
    }
    
    func testInputPacking() throws {
        let string = try String(contentsOf: input)
        let maps = string.components(separatedBy: "\n\n")
            .map { Matrix2D(string: $0) { line in
                line.map(String.init)
            }}
        
        var score = 0
        for map in maps {
            var map = map
            packMap(&map, inDirection: 0)
            score += computeSumFor(map: map)
        }
        
        XCTAssertEqual(score, 110274)
    }
    
    var nextMapPosition: [Int:Matrix2D<String>] = [:]
    var history: [Matrix2D<String>] = []
    
    func testExamplePacking2() throws {
        let string = try String(contentsOf: example)
        let maps = string.components(separatedBy: "\n\n")
            .map { Matrix2D(string: $0) { line in
                line.map(String.init)
            }}
        
        let map = maps[0]
        
        XCTAssertEqual(computeValue(for: map), 64)
    }
    
    func testInputPacking2() throws {
        let string = try String(contentsOf: input)
        let maps = string.components(separatedBy: "\n\n")
            .map { Matrix2D(string: $0) { line in
                line.map(String.init)
            }}
        
        let map = maps[0]
        
        XCTAssertEqual(computeValue(for: map), 90982)
    }
    
    func computeValue(for map: Matrix2D<String>, loops max: Int = 1000000000) -> Int {
        var map = map
        var loop: [Matrix2D<String>] = []
        
        func cycle(_ map: inout Matrix2D<String>) {
            packMap(&map, inDirection: 0)
            packMap(&map, inDirection: 1)
            packMap(&map, inDirection: 2)
            packMap(&map, inDirection: 3)
        }
        
        for count in 1...max {
            history.append(map)
            
            if count % 10 == 0 {
                print(count)
            }

            let currentHash = map.hashValue
            if let nextMap = nextMapPosition[currentHash] {
                map = nextMap
                if nextMap == loop.first {
                    print("found a loop")
                    break
                }
                
                loop.append(map)
            } else {
                cycle(&map)
                loop = []
            }
            
            //print(map)
            nextMapPosition[currentHash] = map
        }
        
        let loopBegin = history.count - loop.count
        
        //print(history.map(computeSumFor))
        
        let remainder = (max-loopBegin) % loop.count
        
        print("found loop of \(loop.count) cycles")
        print("Began loop at \(loopBegin)")
        print("Had \(max-loopBegin) cycles remaining")
        print("\(remainder) non-redundant cycles remaining")
        print(loop[remainder])
        
        return computeSumFor(map: loop[remainder])
    }
    
    func packMap(_ map: inout Matrix2D<String>, inDirection direction: Int) {
        switch direction {
        case 0, 2:
            //up
            var columns = [MatrixColumn<String>]()
            for column in map.columns {
                columns.append(packColumn(column, ascending: direction == 0))
            }
            map = Matrix2D(columns: columns)
            //print(map)
        case 1, 3:
            for (offset, row) in map.enumerated() {
                map[offset] = packRow(row, ascending: direction == 1)
            }
            break
        default:
            fatalError()
        }
    }
    
}
