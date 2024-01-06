//
//  Day17.swift
//  Advent2023Tests
//
//  Created by Mike Muszynski on 12/18/23.
//

import XCTest
@testable import Advent2023
import BundleURL

final class Day17: XCTestCase {
    
    let input = #bundleURL("inputDay17")!
    let example = #bundleURL("exampleDay17")!
    
    func testSimple() throws {
        let string = """
                    1 2
                    3 1
                    """
        
        let matrix = Matrix2D(string: string) { line in
            line.enumerated().map(\.element).compactMap(String.init).compactMap(Int.init)
        }
        let controller = CrucibleGraphController(matrix: matrix)
        let path = controller.graph.dijkstraWithDay17Restrictions(from: "0,0", to: "1,1")
        print(path)
        XCTAssertEqual(path.dropFirst().compactMap{ matrix.element(at: $0) }.sum, 3)
    }
    
    func testLessSimple() throws {
        let string = """
                    1 2 3
                    3 1 3
                    3 3 2
                    """
        
        let matrix = Matrix2D(string: string) { line in
            line.enumerated().map(\.element).compactMap(String.init).compactMap(Int.init)
        }
        let controller = CrucibleGraphController(matrix: matrix)
        let path = controller.graph.dijkstraWithDay17Restrictions(from: "0,0", to: "2,2")
        print(path)
        XCTAssertEqual(path.dropFirst().compactMap{ matrix.element(at: $0) }.sum, 8)
    }
    
    func testLongerSimple() throws {
        let string = """
                    1 1 1 1 1
                    3 3 3 4 3
                    3 3 2 1 3
                    4 4 4 1 3
                    5 5 5 5 1
                    """
        
        let matrix = Matrix2D(string: string) { line in
            line.enumerated().map(\.element).compactMap(String.init).compactMap(Int.init)
        }
        let controller = CrucibleGraphController(matrix: matrix)
        let path = controller.graph.dijkstraWithDay17Restrictions(from: "0,0", to: "4,4")
        print(path)
        XCTAssertEqual(path.dropFirst().compactMap{ matrix.element(at: $0) }.sum, 13)
    }
    
    func testEvenLongerSimple() throws {
        let string = """
                    5 4 5 5 5
                    4 5 5 5 5
                    5 5 5 5 5
                    5 5 5 5 5
                    5 5 5 5 5
                    """
        
        let matrix = Matrix2D(string: string) { line in
            line.enumerated().map(\.element).compactMap(String.init).compactMap(Int.init)
        }
        let controller = CrucibleGraphController(matrix: matrix)
        let path = controller.graph.dijkstraWithDay17Restrictions(from: "0,0", to: "4,4")
        print(path)
        XCTAssertEqual(path.dropFirst().compactMap{ matrix.element(at: $0) }.sum, 5 * 8 - 1)
    }
    
    func testDifficultPortionOfExample() {
        let string = """
        536
        454
        766
        """
        
        let matrix = Matrix2D(string: string) { line in
            line.enumerated().map(\.element).compactMap(String.init).compactMap(Int.init)
        }
        
        print(matrix)
        
        let controller = CrucibleGraphController(matrix: matrix)
        
        XCTAssertEqual(controller.graph.nodes.count, 9)
        XCTAssertEqual(controller.graph.edges.count, 24)
        XCTAssertEqual(controller.graph.nodes.map(\.row).max()!, 2)

        
        let path = controller.graph.dijkstraWithDay17Restrictions(from: "0,0", to: "2,2")
        XCTAssertEqual(path.dropFirst().compactMap{ matrix.element(at: $0) }.sum, 18)
    }
    
    func testExample() throws {
        let string = try String(contentsOf: example)
        var matrix = Matrix2D(string: string) { line in
            line.enumerated().map(\.element).compactMap(String.init).compactMap(Int.init)
        }
        
        let controller = CrucibleGraphController(matrix: matrix)
        XCTAssertEqual(controller.graph.nodes.count, 13 * 13)
        XCTAssertEqual(controller.graph.edges.count, 4 * 2 + 11 * 3 * 4 + 11 * 11 * 4)
        
        let path = controller.graph.dijkstraWithDay17Restrictions(from: "0,0", to: "12,12")
        XCTAssertEqual(path.dropFirst().compactMap{ matrix.element(at: $0) }.sum, 102)
                
        print(matrix)
        var description = "     " + (0..<matrix.columnCount).map { String(format: "[%2d]", $0) }.joined() + "\r"
        for (row, elements) in matrix.enumerated() {
            description.append(elements.enumerated().map {
                var string = $0.offset == 0 ? String(format: "[%2d] ", row) : ""
                let coord = Coordinate(row: row, col: $0.offset)
                if path.contains(coord) {
                    string += String(format: "(%2d)", $0.element).replacingOccurrences(of: "( ", with: " (")
                } else {
                    string += String(format: " %2d ", $0.element)
                }
                
                return string
            }.joined() + "\n")
        }
        print(description)
        
        let exampleString =
        """
        2>>34^>>>1323
        32v>>>35v5623
        32552456v>>54
        3446585845v52
        4546657867v>6
        14385987984v4
        44578769877v6
        36378779796v>
        465496798688v
        456467998645v
        12246868655<v
        25465488877v5
        43226746555v>
        """
        let exampleMatrix = Matrix2D(string: exampleString) { line in
            line.map(String.init)
        }
        let examplePath = exampleMatrix.coordinates { string in
            "v><^".contains(string)
        }
        description = "     " + (0..<matrix.columnCount).map { String(format: "[%2d]", $0) }.joined() + "\r"
        for (row, elements) in matrix.enumerated() {
            description.append(elements.enumerated().map {
                var string = $0.offset == 0 ? String(format: "[%2d] ", row) : ""
                let coord = Coordinate(row: row, col: $0.offset)
                if examplePath.contains(coord) {
                    string += String(format: "(%2d)", $0.element).replacingOccurrences(of: "( ", with: " (")
                } else {
                    string += String(format: " %2d ", $0.element)
                }
                
                return string
            }.joined() + "\n")
        }
        print(description)
    }
}
