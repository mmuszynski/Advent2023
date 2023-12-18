//
//  Day13.swift
//  Advent2023Tests
//
//  Created by Mike Muszynski on 12/16/23.
//

import XCTest
import BundleURL
@testable import Advent2023

extension MatrixRow where Element == String {
    func variance(from other: MatrixRow<String>) -> Int {
        guard self.count == other.count else { return self.count }
        return self.enumerated().compactMap { (offset, element) in
            element == other[offset] ? nil : 1
        }.count
    }
}

extension MatrixColumn where Element == String {
    func variance(from other: MatrixColumn<String>) -> Int {
        guard self.count == other.count else { return self.count }
        return self.enumerated().compactMap { (offset, element) in
            element == other[offset] ? nil : 1
        }.count
    }
}

extension Matrix2D where Element == String {

    func isMirroredStarting(row: Int, tolerance: Int = 0) -> Bool {
        guard row <= self.rowCount else { return false }
        
        //turn them into strings
        //reverse one
        //check to see if either one is contained int he other
        let splitOne = self.prefix(row)
        let splitTwo = self[row..<self.rowCount].reversed()
        
        if splitOne.count == 0 || splitTwo.count == 0 { return false }
        
        //MatrixRowVersion
        var splitOneArray = Array(splitOne)
        var splitTwoArray = Array(splitTwo)
        var variances: Int = 0
        while let one = splitOneArray.popLast(),
              let two = splitTwoArray.popLast() {
            variances += one.variance(from: two)
        }
        return variances == tolerance
        
//        //String version
//        let stringOne = splitOne.joined()
//        let stringTwo = splitTwo.joined()
//        return stringOne.hasPrefix(stringTwo) || stringTwo.hasPrefix(stringOne)
    }
    
    func isMirroredStarting(col: Int, tolerance: Int = 0) -> Bool {
        guard col <= self.columnCount else { return false }
        let splitOne = self.columns.prefix(col)
        let splitTwo = self.columns[col..<self.columnCount].reversed()
        
        if splitOne.count == 0 || splitTwo.count == 0 { return false }
        
        //MatrixColVersion
        var splitOneArray = Array(splitOne)
        var splitTwoArray = Array(splitTwo)
        var variances: Int = 0
        while let one = splitOneArray.popLast(),
              let two = splitTwoArray.popLast() {
            variances += one.variance(from: two)
        }
        return variances == tolerance

        
//        if splitOne.count == 0 || splitTwo.count == 0 { return false }
//        return splitOne.hasPrefix(splitTwo) || splitTwo.hasPrefix(splitOne)
    }
}

extension MatrixRow where Element == String {
    init(string: String) {
        self.init(string.map(String.init))
    }
    
    func differsByOne(from other: MatrixRow<String>) -> Bool {
        guard self.count == other.count else { return false }
        return self.enumerated().compactMap { (offset, element) in
            element == other[offset] ? nil : 1
        }.count == 1
    }
}

final class Day13: XCTestCase {
    
    let input = #bundleURL("inputDay13")!
    let example = #bundleURL("exampleDay13")!
    
    func testExampleReflections() throws {
        let string = try String(contentsOf: example)
        let maps = string.components(separatedBy: "\n\n")
            .map {
                Matrix2D(string: $0) { string in
                    return string.enumerated().map(\.element).map(String.init)
                }
            }
        
        XCTAssertFalse(maps[1].isMirroredStarting(row: 3))
        XCTAssertFalse(maps[1].isMirroredStarting(row: 0))
        XCTAssertFalse(maps[1].isMirroredStarting(row: 6))
        XCTAssertFalse(maps[0].isMirroredStarting(col: 1))
        XCTAssertFalse(maps[1].isMirroredStarting(col: 1))

        XCTAssertTrue(maps[0].isMirroredStarting(col: 5))
        XCTAssertTrue(maps[1].isMirroredStarting(row: 4))


    }
    
    func testExampleDay13() throws {
        let string = try String(contentsOf: example)
        let maps = string.components(separatedBy: "\n\n")
            .map {
                Matrix2D(string: $0) { string in
                    return string.enumerated().map(\.element).map(String.init)
                }
            }
        
        var score = 0
        for map in maps {
            for col in 1...map.columnCount {
                if map.isMirroredStarting(col: col) {
                    score += col
                }
            }
            
            for row in 1...map.rowCount {
                if map.isMirroredStarting(row: row) {
                    score += row * 100
                }
            }
        }
        XCTAssertEqual(score, 405)

    }
    
    func testInputDay13() throws {
        let string = try String(contentsOf: input)
        let maps = string.components(separatedBy: "\n\n")
            .map { Matrix2D(string: $0) {
                return $0.enumerated().map(\.element).map(String.init)
            }}
        
        var score = 0
        for map in maps {
            for col in 1...map.columnCount {
                if map.isMirroredStarting(col: col) {
                    score += col
                }
            }
            
            for row in 1...map.rowCount {
                if map.isMirroredStarting(row: row) {
                    score += row * 100
                }
            }
        }
        
        XCTAssertEqual(score, 36448)
        
    }
        
    func adjacentRowsNearlyIdentical(in map: Matrix2D<String>) -> [Int] {
        var returnValue = [Int]()
        
        for i in 0..<map.rowCount-1 {
            let firstRow = map[i]
            let secondRow = map[i+1]
                    
            if firstRow.differsByOne(from: secondRow) {
                returnValue.append(i)
            }
        }
        
        return returnValue
    }
    
    func testDiffersByOne() throws {
        let all: MatrixRow<String> = MatrixRow(string: "######")
        let one: MatrixRow<String> = MatrixRow(string: "###.##")
        let two: MatrixRow<String> = MatrixRow(string: "###..#")
        
        XCTAssertTrue(all.differsByOne(from: one))
        XCTAssertTrue(one.differsByOne(from: two))
        XCTAssertFalse(all.differsByOne(from: two))
        XCTAssertFalse(all.differsByOne(from: all))
    }
    
    func testExampleDay13Part2() throws {
        let string = try String(contentsOf: example)
        let maps = string.components(separatedBy: "\n\n")
            .map { Matrix2D(string: $0) {
                return $0.enumerated().map(\.element).map(String.init)
            }}
        
        XCTAssertEqual(adjacentRowsNearlyIdentical(in: maps[1]), [0])
        XCTAssertEqual(adjacentRowsNearlyIdentical(in: maps[0]), [])
        
        var score = 0
        for map in maps {
            for col in 1...map.columnCount {
                if map.isMirroredStarting(col: col, tolerance: 1) {
                    score += col
                }
            }
            
            for row in 1...map.rowCount {
                if map.isMirroredStarting(row: row, tolerance: 1) {
                    score += row * 100
                }
            }
        }
        XCTAssertEqual(score, 400)
    }
    
    func testInputDay13Part2() throws {
        let string = try String(contentsOf: input)
        let maps = string.components(separatedBy: "\n\n")
            .map { Matrix2D(string: $0) {
                return $0.enumerated().map(\.element).map(String.init)
            }}
        
        var score = 0
        for map in maps {
            for col in 1...map.columnCount {
                if map.isMirroredStarting(col: col, tolerance: 1) {
                    score += col
                }
            }
            
            for row in 1...map.rowCount {
                if map.isMirroredStarting(row: row, tolerance: 1) {
                    score += row * 100
                }
            }
        }
        
        XCTAssertEqual(score, 35799)
        
    }
    
}
