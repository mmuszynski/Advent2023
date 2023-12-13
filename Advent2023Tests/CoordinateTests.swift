//
//  MatrixTests.swift
//  Advent2023Tests
//
//  Created by Mike Muszynski on 12/13/23.
//

import XCTest
@testable import Advent2023

final class CoordinateTests: XCTestCase {
    
    func testStepwiseDistance() throws {
        //row 6 col 1
        //row 11 col 5
        
        let coord1 = Coordinate(row: 6, col: 1)
        let coord2 = Coordinate(row: 11, col: 5)
        
        XCTAssertEqual(coord1.distance(from: coord2), 9)
    }
    
}
