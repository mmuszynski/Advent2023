//
//  MatrixTests.swift
//  Advent2023Tests
//
//  Created by Mike Muszynski on 12/13/23.
//

import XCTest
@testable import Advent2023

final class AllSatisfyTest: XCTestCase {
    
    func testAllSatisfy() throws {
        XCTAssertTrue([true].all)
        XCTAssertTrue([true, true, true, true, true].all)
        XCTAssertTrue([true, true, true, true, true, true, true, true, true, true].all)
        XCTAssertFalse([true, true, true, true, true, true, false].all)
    }
}
