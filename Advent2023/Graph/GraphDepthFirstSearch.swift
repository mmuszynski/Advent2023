//
//  GraphDepthFirstSearch.swift
//  Advent2023
//
//  Created by Mike Muszynski on 1/2/24.
//

import Foundation

extension Graph {
    func depthFirstSearch(start initialNode: Node) -> Set<Node> {
        var frontier: Array<Node> = [initialNode]
        var visited: [Node : Bool] = [:]
        
        while !frontier.isEmpty {
            let node = frontier.removeFirst()
            visited[node] = true

            let neighbors = self.neighbors(of: node)
            let unvisitedNeighbors = neighbors.filter { visited[$0] != true }
            
            frontier.append(contentsOf: unvisitedNeighbors)
            unvisitedNeighbors.forEach { visited[$0] = true }
        }
        
        return Set(visited.keys)
    }
}
