//
//  CrucibleGraph.swift
//  Advent2023
//
//  Created by Mike Muszynski on 1/5/24.
//

import Foundation
import Graph
import Coordinate

struct CrucibleNode: Equatable, Hashable {
    var coordinate: Coordinate
    var direction: Coordinate
    var steps: Int
}

class CrucibleGraphController {
    
    var graph: WeightedGraph<CrucibleNode>
    
    init(matrix: Matrix2D<Int>, partOne: Bool = true) {
        self.graph = WeightedGraph()
        let directions = Coordinate.cardinalDirections
        
        func weight(for coordinate: Coordinate) -> Int? {
            guard (0..<matrix.rowCount).contains(coordinate.row) else { return nil }
            guard (0..<matrix.columnCount).contains(coordinate.col) else { return nil }
            return matrix[coordinate.row][coordinate.col]
        }
        
        for row in 0..<matrix.rowCount {
            for col in 0..<matrix.columnCount {
                let current = Coordinate(row: row, col: col)
                
                let neighborCoords = directions
                    .map { $0 + current }
                
                if partOne {
                    
                    for steps in 0...3 {
                        for neighbor in neighborCoords {
                            guard let weight = matrix.element(at: neighbor) else { continue }
                            
                            let neighborDirection = neighbor - current
                            for direction in directions.filter({ $0 != neighborDirection.flipped }) {
                                let currentNode = CrucibleNode(coordinate: current, direction: direction, steps: steps)
                                
                                let neighborSteps = direction == neighborDirection ? steps + 1 : 1
                                if neighborSteps > 3 { continue }
                                
                                let neighborNode = CrucibleNode(coordinate: neighbor, direction: neighborDirection, steps: neighborSteps)
                                
                                graph.addEdge(from: currentNode, to: neighborNode, weight: weight)
                            }
                        }
                    }
                    
                } else {
                    
                    for steps in 0...10 {
                        for neighbor in neighborCoords {
                            guard let weight = matrix.element(at: neighbor) else { continue }
                            
                            let neighborDirection = neighbor - current
                            
                            if steps < 4 {
                                for direction in directions.filter({ $0 == neighborDirection }) {
                                    let currentNode = CrucibleNode(coordinate: current, direction: direction, steps: steps)
                                    let neighborNode = CrucibleNode(coordinate: neighbor, direction: neighborDirection, steps: steps + 1)
                                    graph.addEdge(from: currentNode, to: neighborNode, weight: weight)
                                }
                            } else {
                                for direction in directions.filter({ $0 != neighborDirection.flipped }) {
                                    let currentNode = CrucibleNode(coordinate: current, direction: direction, steps: steps)
                                    
                                    let neighborSteps = direction == neighborDirection ? steps + 1 : 1
                                    if neighborSteps > 10 { continue }
                                    
                                    let neighborNode = CrucibleNode(coordinate: neighbor, direction: neighborDirection, steps: neighborSteps)
                                    
                                    graph.addEdge(from: currentNode, to: neighborNode, weight: weight)
                                }
                            }
                        }
                    }
                    
                }
            }
        }
    }
    
}

extension Graph where Node == CrucibleNode {
    
    func dijkstraField(from start: Coordinate) -> [Node : Int] {
        dijkstraRaw(from: start).0
    }
    
    func dijkstra(from start: Coordinate, to end: Coordinate) -> [Node] {
        let raw = dijkstraRaw(from: start)
        guard let lowCost = raw.0.filter({ node in
            node.key.coordinate == end
        }).min(by: { $0.value < $1.value }) else {
            return []
        }
        
        let cameFrom = raw.1
        var path = [Node]()
        path.append(lowCost.key)
        while let last = path.last,
              let next = cameFrom[last] {
            path.append(next)
        }
        return path.reversed()
    }
    
    func dijkstraRaw(from start: Coordinate) -> ([Node: Int], [Node: Node]) {
        var frontier = Heap<NodeCost<Node, Int>>(comparator: <)
        
        var cameFrom: [Node : Node] = [:]
        var costSoFar: [Node : Int] = [:]
        
        for direction in Coordinate.cardinalDirections {
            let node = CrucibleNode(coordinate: start, direction: direction, steps: 0)
            frontier.insert(item: NodeCost(node: node, cost: 0))
            costSoFar[node] = 0
        }
        
        var frontierCount = frontier.count
        
        while let current = frontier.popTop() {
            let currentNode = current.node
            let neighbors = neighbors(of: currentNode)
            
            for neighbor in neighbors {
                let newCost = (costSoFar[currentNode] ?? 0) + self.cost(from: currentNode, to: neighbor)
                if newCost > (costSoFar[neighbor] ?? .max) { continue }
                if newCost == costSoFar[neighbor] { continue }
                
                costSoFar[neighbor] = newCost
                frontier.insert(item: NodeCost(node: neighbor, cost: newCost))
                cameFrom[neighbor] = currentNode
            }
            
            frontierCount = max(frontierCount, frontier.count)
        }
        
        print(frontierCount)
        
        return (costSoFar, cameFrom)
    }
}
