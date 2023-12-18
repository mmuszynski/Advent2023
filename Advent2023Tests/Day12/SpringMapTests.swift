//
//  Day10.swift
//  Advent2023Tests
//
//  Created by Mike Muszynski on 12/11/23.
//

import XCTest
import BundleURL
@testable import Advent2023

final class SpringMapTests: XCTestCase {
    
    func testExampleCombinations() throws {
        let row: SpringStatusRow = "#?."
        let combs = row.allCombinations
        
        XCTAssertTrue(combs.contains("##."))
        XCTAssertTrue(combs.contains("#.."))
        
        let row2: SpringStatusRow = "??"
        let combs2 = row2.allCombinations
        
        XCTAssertEqual(combs2.count, 4)
        
        let satisfies = combs2.filter { $0.satsfies([1])}
        XCTAssertEqual(satisfies.count, 2)

        let testRow: SpringStatusRow = "???.###"
        XCTAssertEqual(testRow.allCombinations.filter { $0.satsfies([1,1,3]) }.count, 1)
        
        let testRow2: SpringStatusRow = "?###????????"
        XCTAssertEqual(testRow2.allCombinations.filter { $0.satsfies([3,2,1]) }.count, 10)
    }
}
