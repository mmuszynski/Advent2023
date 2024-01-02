//
//  GraphDepthFirstSearch.swift
//  Advent2023
//
//  Created by Mike Muszynski on 1/2/24.
//

import Foundation

extension Graph {
    func depthFirstSearch(start initialNode: Node) {
        var frontier: Array<Node> = [initialNode]
        var visited: [Node : Bool] = [:]
        
        while !frontier.isEmpty {
            let node = frontier.removeFirst()
            visited[node] = true
            
            let neighbors = structure[node.hashValue]?.map(\.destination) ?? []
            let neighborNodes = neighbors.compactMap { nodeLookup[$0] }
            let unvisitedNeighbors = neighborNodes.filter { visited[$0] != true }
            
            frontier.append(contentsOf: unvisitedNeighbors)
            unvisitedNeighbors.forEach { visited[$0] = true }
        }
    }
}
