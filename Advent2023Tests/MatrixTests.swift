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
        let matrix = Matrix2D(string: string) { line in
            return line.components(separatedBy: .whitespaces)
        }
        XCTAssertEqual(matrix.columnCount, 4)
        XCTAssertEqual(matrix.rowCount, 2)
        XCTAssertEqual(matrix[0][0], "This")
    }
    
    func testInsertAndRemove() throws {
        var matrix = Matrix2D(repeating: [0, 1, 2], count: 3)
        XCTAssertEqual(matrix.rowCount, 3)
        XCTAssertEqual(matrix.columnCount, 3)
        
        matrix.insert([100, 1, 0], at: 0)
        XCTAssertEqual(matrix.rowCount, 4)
        XCTAssertEqual(matrix.columnCount, 3)
        
        matrix.insertColumn([0, 0, 0, 3], at: 0)
        XCTAssertEqual(matrix.rowCount, 4)
        XCTAssertEqual(matrix.columnCount, 4)
        XCTAssertEqual(matrix[3][3], 3)

        matrix.replaceColumn(at: 0, with: [9, 9, 9, 9])
        XCTAssertEqual(matrix[0][0], 9)
        
        matrix.removeColumn(at: 0)
        XCTAssertEqual(matrix.rowCount, 4)
        XCTAssertEqual(matrix.columnCount, 3)
        XCTAssertEqual(matrix[0][0], 100)
        
        matrix.remove(at: 0)
        XCTAssertEqual(matrix.rowCount, 3)
        XCTAssertEqual(matrix.columnCount, 3)
        XCTAssertEqual(matrix[0][0], 0)
    }
    
    func testColumnGetterPerformance() throws {
        let matrix = Matrix2D(repeating: MatrixRow(repeating: Int.random(in: 0...10), count: 100), count: 100)
        XCTAssertEqual(matrix.rowCount, 100)
        XCTAssertEqual(matrix.columnCount, 100)
        measure {
            let _ = matrix.columns
        }
    }
    
    func testColumnGetter() throws {
        var matrix = Matrix2D(repeating: MatrixRow(repeating: 1, count: 10), count: 10)
        matrix.replaceColumn(at: 1, with: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0])
        print(matrix)
        print(matrix.columns)
    }
    
}
