//
//  CrucibleGraph.swift
//  Advent2023
//
//  Created by Mike Muszynski on 1/5/24.
//

import Foundation
import Graph

class CrucibleGraphController {
    
    var graph: WeightedGraph<Coordinate>
    
    init(matrix: Matrix2D<Int>) {
        self.graph = WeightedGraph()
        let directions = Coordinate.cardinalDirections
        
        func weight(for coordinate: Coordinate) -> Int? {
            guard (0..<matrix.rowCount).contains(coordinate.row) else { return nil }
            guard (0..<matrix.columnCount).contains(coordinate.col) else { return nil }
            return matrix[coordinate.row][coordinate.col]
        }
        
        for row in 0..<matrix.rowCount {
            for col in 0..<matrix.columnCount {
                let coordinate = Coordinate(row: row, col: col)
                let neighborCoords = directions
                    .map { $0 + coordinate }
                
                for neighbor in neighborCoords {
                    guard let weight = matrix.element(at: neighbor) else { continue }
                    graph.addEdge(from: coordinate, to: neighbor, weight: weight)
                }
            }
        }
    }
    
}

fileprivate struct NodeCostWithSteps<Node, Cost>: Comparable where Cost: Comparable {
    static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.cost < rhs.cost
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.cost == rhs.cost
    }
    
    var node: Node
    var cost: Cost
    var steps: Int
    var direction: Coordinate
    
    init(node: Node, cost: Cost, steps: Int, direction: Coordinate) {
        self.node = node
        self.cost = cost
        self.steps = steps
        self.direction = direction
    }
}

extension Graph where Node == Coordinate {
    
    public func dijkstraWithDay17Restrictions(from startNode: Node, to endNode: Node) -> [Node] {
        var frontier = Heap<NodeCostWithSteps<Node, Int>>(comparator: <)
        frontier.insert(item: NodeCostWithSteps(node: startNode, cost: 0, steps: 0, direction: .zero))

        var cameFrom: [Node : Node] = [:]
        var costSoFar: [Node : Int] = [:]
        
        costSoFar[startNode] = 0
        
        while let current = frontier.popTop() {
            let currentNode = current.node
            if currentNode == endNode { break }
            
            let neighbors = neighbors(of: currentNode)
            
            for neighbor in neighbors {
                let newCost = (costSoFar[currentNode] ?? 0) + self.cost(from: currentNode, to: neighbor)
                if newCost > (costSoFar[neighbor] ?? .max) { continue }
                
                //is the neighbor in the same direction?
                var steps = current.steps
                if let previous = cameFrom[currentNode] {
                    let direction = current.direction
                    let nextDirection = neighbor - currentNode
                    if direction == nextDirection {
                        steps += 1
                    } else {
                        steps = 1
                    }
                } else {
                    steps = 1
                }
                
                if steps > 3 {
                    continue
                }
                
//                if costSoFar[neighbor] != nil {
//                    print("revisited \(neighbor) from \(currentNode)")
//                    print("old cost: \(costSoFar[neighbor]!)")
//                    print("new cost: \(newCost)")
//                }
                
                costSoFar[neighbor] = newCost
                frontier.insert(item: NodeCostWithSteps(node: neighbor, cost: newCost, steps: steps, direction: neighbor - currentNode))
                cameFrom[neighbor] = currentNode
            }
        }
        
        var location: Node? = endNode
        var path = [Node]()
        guard cameFrom.keys.contains(endNode) else { return [] }
        while location != nil, location != startNode {
            path.append(location!)
            location = cameFrom[location!]
        }
        path.append(startNode)
        
        var matrixString = ""
        for row in 0..<(self.nodes.map(\.row).max()! + 1) {
            var rowString = ""
            for col in 0..<(self.nodes.map(\.col).max()! + 1) {
                let coord = Coordinate(row: row, col: col)
                let string = String(describing: costSoFar[coord] ?? -1)
                rowString.append((path.contains(coord) ? "x" : "") + string)
                rowString.append("\t")
            }
            
            matrixString += rowString + "\r"
        }
        print(matrixString)
        
        return path.reversed()
    }
}
