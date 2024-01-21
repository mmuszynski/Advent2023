//
//  Day17.swift
//  Advent2023Tests
//
//  Created by Mike Muszynski on 12/18/23.
//

import XCTest
@testable import Advent2023
import BundleURL
import Coordinate

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
        
        let costs = controller.graph.dijkstraField(from: .zero)
        XCTAssertEqual(costs.filter { element in
            element.key.coordinate.x == 1 && element.key.coordinate.y == 1
        }.map(\.value).min(), 3)
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
        
        let costs = controller.graph.dijkstraField(from: .zero)
        let rows = matrix.rowCount
        let cols = matrix.columnCount
        XCTAssertEqual(costs.filter { element in
            element.key.coordinate.row == rows - 1 && element.key.coordinate.col == cols - 1
        }.map(\.value).min(), 8)
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
        let costs = controller.graph.dijkstraField(from: .zero)
        let rows = matrix.rowCount
        let cols = matrix.columnCount
        XCTAssertEqual(costs.filter { element in
            element.key.coordinate.row == rows - 1 && element.key.coordinate.col == cols - 1
        }.map(\.value).min(), 13)
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
        
        let controller = CrucibleGraphController(matrix: matrix)
        
        let costs = controller.graph.dijkstraField(from: .zero)
        let rows = matrix.rowCount
        let cols = matrix.columnCount
        XCTAssertEqual(costs.filter { element in
            element.key.coordinate.row == rows - 1 && element.key.coordinate.col == cols - 1
        }.map(\.value).min(), 18)
        
    }
    
    func testExample() throws {
        let string = try String(contentsOf: example)
        let matrix = Matrix2D(string: string) { line in
            line.enumerated().map(\.element).compactMap(String.init).compactMap(Int.init)
        }
        
        let controller = CrucibleGraphController(matrix: matrix)
        
        let costs = controller.graph.dijkstraField(from: .zero)
        let rows = matrix.rowCount
        let cols = matrix.columnCount
        
        let finalCosts = costs.filter { element in
            element.key.coordinate.row == rows - 1 && element.key.coordinate.col == cols - 1
        }
        
        let path = controller.graph.dijkstra(from: "0,0", to: "12,12").map { $0.coordinate }
        
        XCTAssertEqual(finalCosts.map(\.value).min(), 102)
        
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
    }
    
    func testInput() throws {
        let string = try String(contentsOf: input)
        let matrix = Matrix2D(string: string) { line in
            line.enumerated().map(\.element).compactMap(String.init).compactMap(Int.init)
        }
        
        let controller = CrucibleGraphController(matrix: matrix)
        
        let costs = controller.graph.dijkstraField(from: .zero)
        let rows = matrix.rowCount
        let cols = matrix.columnCount
        
        let finalCosts = costs.filter { element in
            element.key.coordinate.row == rows - 1 && element.key.coordinate.col == cols - 1
        }
        
        XCTAssertEqual(finalCosts.map(\.value).min(), 814)
    }
    
    func testExamplePart2() throws {
        let string = try String(contentsOf: example)
        let matrix = Matrix2D(string: string) { line in
            line.enumerated().map(\.element).compactMap(String.init).compactMap(Int.init)
        }
        
        let controller = CrucibleGraphController(matrix: matrix, partOne: false)
        let costs = controller.graph.dijkstraField(from: .zero)
        let rows = matrix.rowCount
        let cols = matrix.columnCount
        
        let finalCosts = costs.filter { element in
            element.key.coordinate.row == rows - 1 && element.key.coordinate.col == cols - 1
        }
        
        XCTAssertEqual(finalCosts.map(\.value).min(), 94)
    }
    
    func testInputPart2() throws {
        #warning("almost 30 seconds")
        let string = try String(contentsOf: input)
        let matrix = Matrix2D(string: string) { line in
            line.enumerated().map(\.element).compactMap(String.init).compactMap(Int.init)
        }
        
        let controller = CrucibleGraphController(matrix: matrix, partOne: false)
        let costs = controller.graph.dijkstraField(from: .zero)
        let rows = matrix.rowCount
        let cols = matrix.columnCount
        
        let finalCosts = costs.filter { element in
            element.key.coordinate.row == rows - 1 && element.key.coordinate.col == cols - 1
        }
        
        XCTAssertEqual(finalCosts.map(\.value).min(), 974)
    }
}
