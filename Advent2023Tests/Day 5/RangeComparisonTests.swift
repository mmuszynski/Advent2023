//
//  RangeComparisonTests.swift
//  Advent2023Tests
//
//  Created by Mike Muszynski on 12/7/23.
//

import XCTest
@testable import Advent2023

final class RangeComparisonTests: XCTestCase {
    
    func testCombineGardenRanges() throws {
        let range = GardenRange(range: 0..<5)
        let otherRange = GardenRange(range: 3..<8, map: 5)
        
        XCTAssertEqual(otherRange.sourceRange, 3..<8)
        XCTAssertEqual(otherRange.destinationRange, 8..<13)
        
        let combined = range.combine(with: otherRange)
        
        XCTAssertTrue(combined.contains(GardenRange(range: 3..<5, map: 5)))
        XCTAssertTrue(combined.contains(GardenRange(range: 0..<3)))
        
        print(combined)
    }
    
    func testExclude() throws {
        var range = 0..<10
        var otherRange = 5..<6
        
        var exclusive = range.excluding(otherRange)
        XCTAssertEqual(exclusive.count, 2)
        XCTAssertTrue(exclusive.contains(0..<5))
        XCTAssertTrue(exclusive.contains(6..<10))
        
        range = 0..<5
        otherRange = 3..<10
        exclusive = range.excluding(otherRange)
        XCTAssertEqual(exclusive.count, 1)
        XCTAssertTrue(exclusive.contains(0..<3))
        
        range = 0..<10
        otherRange = -10..<10
        exclusive = range.excluding(otherRange)
        XCTAssertEqual(exclusive.count, 0)

        range = 5..<10
        otherRange = 0..<7
        exclusive = range.excluding(otherRange)
        XCTAssertEqual(exclusive.count, 1)
        XCTAssertTrue(exclusive.contains(7..<10))
        
        print(exclusive)
    }
    
    func testEntirelyLess() {
        let range = 0..<15
        let otherRange = 81..<95
        let exclusive = range.excluding(otherRange)
        XCTAssertEqual(exclusive.count, 1)
        XCTAssertTrue(exclusive.contains(0..<15))
    }
    
    func testEntirelyGreater() {
        let range = 100..<115
        let otherRange = 81..<95
        let exclusive = range.excluding(otherRange)
        XCTAssertEqual(exclusive.count, 1)
        XCTAssertTrue(exclusive.contains(100..<115), "\(exclusive)")
    }

}
