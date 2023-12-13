//
//  MatrixTests.swift
//  Advent2023Tests
//
//  Created by Mike Muszynski on 12/13/23.
//

import XCTest
@testable import Advent2023

final class MatrixTests: XCTestCase {
    
    func testInitMatrixWithStrings() throws {
        //let unequalMatrix: Matrix2D = [[1, 2], [1, 2, 3], [1]]
        //Matrix2D([[1, 2], [1, 2, 3], [1]])
        
        let matrix = Matrix2D([["1"], ["1"], ["1"]])
        XCTAssertTrue(matrix[0].allSatisfy { value in
            value == "1"
        })
    }
    
    func testInitWithString() throws {
        let string = "This is a test\nof strings in matrix"
        let matrix = try Matrix2D(string: string) { line in
            return line.components(separatedBy: .whitespaces)
        }
        XCTAssertEqual(matrix.columnCount, 4)
        XCTAssertEqual(matrix.rowCount, 2)
        XCTAssertEqual(matrix[0][0], "This")
    }
    
}
