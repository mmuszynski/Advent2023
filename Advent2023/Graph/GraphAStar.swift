//
//  GraphAStar.swift
//  Advent2023
//
//  Created by Mike Muszynski on 1/2/24.
//

import Foundation

extension Graph {
    func aStar(from startNode: Node, to endNode: Node) -> [Node] {
        var frontier: [Node] = [startNode]
        var breadcrumbs: [Node : Node] = [:]
        
        while !frontier.isEmpty {
            let current = frontier.removeFirst()
            let neighbors = neighbors(of: current)
                .filter {
                    !breadcrumbs.keys.contains($0) && $0 != startNode
                }
            frontier.append(contentsOf: neighbors)
            neighbors.forEach { breadcrumbs[$0] = current }
            
            if current == endNode { break }
        }
        
        var path = [endNode]
        while let node = path.last, let next = breadcrumbs[node] {
            path.append(next)
        }
        
        return path.reversed()
        
//        frontier = Queue()
//        frontier.put(start )
//        came_from = dict() # path A->B is stored as came_from[B] == A
//        came_from[start] = None
//
//        while not frontier.empty():
//           current = frontier.get()
//           for next in graph.neighbors(current):
//              if next not in came_from:
//                 frontier.put(next)
//                 came_from[next] = current
    }
}
