//
//  CyclicalArrayTests.swift
//  Advent2023Tests
//
//  Created by Mike Muszynski on 1/20/24.
//

import XCTest
@testable import Advent2023

final class CyclicalArrayTests: XCTestCase {
    
    func testCyclicalArray() throws {
        var array = CyclicalArray<Int>()
        array.append(1)
        array.append(1)
        
        XCTAssertEqual(array[0], 1)
        XCTAssertEqual(array[1], 1)
        XCTAssertEqual(array[2], 1)
        XCTAssertEqual(array[.max], 1)
        
        array = CyclicalArray()
        array.append(1)
        array.append(2)
        array.append(3)
        array.append(1)
        
        XCTAssertEqual(array[0], 1)
        XCTAssertEqual(array[1], 2)
        XCTAssertEqual(array[2], 3)
        XCTAssertEqual(array[3], 1)
        XCTAssertEqual(array[4], 2)
        XCTAssertEqual(array[5], 3)
    }
}
