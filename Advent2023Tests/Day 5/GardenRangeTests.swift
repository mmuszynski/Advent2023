//
//  GardenRangeTests.swift
//  Advent2023Tests
//
//  Created by Mike Muszynski on 12/9/23.
//

import XCTest
@testable import Advent2023

final class GardenRangeTests: XCTestCase {

    func testGardenRange() {
        XCTAssertEqual(GardenRange(range: 0..<5).sourceRange, GardenRange(range: 0..<5).destinationRange)
        XCTAssertEqual(GardenRange(string: "0 0 5"),
                       GardenRange(range: 0..<5))
        
        let firstExample = GardenRange(string: "50 98 2")
        XCTAssertEqual(firstExample.sourceRange, 98..<100)
        XCTAssertEqual(firstExample.destinationRange, 50..<52)
        
        XCTAssertEqual(GardenRange(range: 0..<5, map: 5).convertedToDestination,
                       GardenRange(range: 5..<10))
    }

}
