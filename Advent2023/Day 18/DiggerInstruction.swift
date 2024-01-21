//
//  DiggerInstruction.swift
//  Advent2023
//
//  Created by Mike Muszynski on 1/7/24.
//

import Foundation
import Graph
import Coordinate

struct DiggerMap {
    var matrix: Matrix2D<String>
    var minimumCoordinate: Coordinate = .zero
    
    func convertCoordinateToMatrixSpace(_ coordinate: Coordinate) -> Coordinate {
        // Example (-4,-4) origin.
        // Given coordinate (-4,-4) return (0,0)
        //-4 + x = 0
        coordinate - minimumCoordinate
    }
    
    init(instructions: [DiggerInstruction]) {
        let rect = instructions.getMapRect()
        
        self.minimumCoordinate = rect.origin
        let size = rect.size
        
        var matrix = Matrix2D(repeating: ".", rows: size.row, cols: size.col)
        var current = Coordinate.zero - minimumCoordinate
        for instruction in instructions {
            for _ in 0..<instruction.length {
                current += instruction.direction
                matrix[current.row][current.col] = "#"
            }
        }
            
        self.matrix = matrix
    }
    
    func createGraph(from matrix: Matrix2D<String>) -> DirectionalGraph<Coordinate> {
        var graph = DirectionalGraph<Coordinate>()
        for row in 0..<matrix.rowCount {
            for col in 0..<matrix.columnCount {
                let coord = Coordinate(row: row, col: col)
                let neighbors = Coordinate.cardinalDirections.map { $0 + coord }
                neighbors.forEach { neighbor in
                    if matrix.element(at: neighbor) == "." {
                        graph.addEdge(from: coord, to: neighbor)
                    }
                }
            }
        }
        return graph
    }
    
    func fill() -> Int {
        let graph = createGraph(from: matrix)
        
        //find the first place where the graph is enclosed
        for (row, column) in matrix.enumerated() {
            if row == 0 { continue }
            var open = true
            for (col, element) in column.enumerated() {
                if element == "#" {
                    open.toggle()
                } else {
                    if !open {
                        print("row: \(row), col: \(col)")
                        let digFill = graph.floodFill(start: Coordinate(row: row, col: col))
                        return matrix.coordinates(where: { $0 == "#" }).count + digFill.count
                    }
                }
            }
        }
        
        return matrix.coordinates { $0 == "#" }.count
    }
    
}

extension Array where Element == DiggerInstruction {
    func getCorners() -> [Coordinate] {
        var corners = [Coordinate.zero]
        for instruction in self {
            let current = corners.last!
            corners.append(current + instruction.vector)
        }
        
        return corners
    }
    
    func getMapRect() -> (origin: Coordinate, size: Coordinate) {
        let corners = self.getCorners()
        return corners.boundingBox
    }
    
    var perimeter: Int {
        self.map(\.length).sum
    }
    
    func shoelace() -> Int {
        let corners = self.getCorners()
        
        let sum = corners.enumerated().reduce(into: (0, 0)) { partialResult, element in
            let idx = element.offset
            let firstIndex = idx
            let secondIndex = (idx + 1) % corners.count
            
            let x1 = element.element.x
            let x2 = corners[secondIndex].x
            let y1 = element.element.y
            let y2 = corners[secondIndex].y
            
            partialResult.0 += x1 * y2
            partialResult.1 += x2 * y1
        }
        let shoelace = abs(sum.0 - sum.1) / 2
        let value = shoelace + self.perimeter / 2 + 1
        return value
    }
}

extension Array where Element == Coordinate {
    var boundingBox: (origin: Coordinate, size: Coordinate) {
        let minX = self.map(\.x).min()!
        let minY = self.map(\.y).min()!
        let maxX = self.map(\.x).max()! + 1
        let maxY = self.map(\.y).max()! + 1
        let max = Coordinate(x: maxX, y: maxY)
        
        return (origin: Coordinate(x: minX, y: minY), size: Coordinate(x: maxX - minX, y: maxY - minY))
    }
}

struct DiggerInstruction {
    var direction: Coordinate
    var length: Int
    var vector: Coordinate {
        self.direction * length
    }
    var hexColor: String
    
    var partTwoInstruction: DiggerInstruction {
        var hex = self.hexColor
        let last = hex.popLast()
        var direction = "R"
        switch last {
        case "1":
            direction = "D"
        case "2":
            direction = "L"
        case "3":
            direction = "U"
        default:
            break
        }
        hex.removeFirst()
        guard let int = Int(hex, radix: 16) else { fatalError() }
        let instructionString = "\(direction) \(int) (\(hexColor))"
        
        return DiggerInstruction(string: instructionString)
    }

    
    init(string: String) {
        let parts = string.components(separatedBy: .whitespaces)
        let distanceString = parts[1]
        
        guard let distance = Int(distanceString) else { fatalError() }
        length = distance
        
        switch parts[0] {
        case "L":
            direction = .left
        case "R":
            direction = .right
        case "U":
            //Note that we increase y as we go down
            //The origin is top left
            direction = .up
        case "D":
            direction = .down
        default:
            fatalError()
        }
        
        hexColor = parts[2].replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "")
    }
}
