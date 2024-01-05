//
//  Graph.swift
//  Advent2023
//
//  Created by Mike Muszynski on 12/29/23.
//

import Foundation

protocol Graph {
    associatedtype Node: Comparable & Hashable
    associatedtype EdgeType: Edge & Equatable
    
    /// The structure of the graph. Nodes are keys to a dictionary that contains their edges
    var structure: [Int : Set<EdgeType>] { get set }
    
    /// Because nodes are stored based on their hash value, there is a lookup table to transfer them back into node form
    var nodeLookup: [Int : Node] { get set }
    
    var nodes: Set<Node> { get set }
    var edges: Set<EdgeType> { get set }
    
    mutating func addNode(_ newNode: Node)
}

extension Graph {
    var edges: Set<EdgeType> {
        structure.values.reduce(Set<EdgeType>()) { partialResult, next in
            partialResult.union(next)
        }
    }
    
    mutating func addNode(_ newNode: Node) {
        guard !nodes.contains(newNode) else { return }
        
        nodes.insert(newNode)
        structure[newNode.hashValue] = []
    }
    
    mutating func remove(node: Node) {
        let id = node.hashValue
        while let index = edges.firstIndex(where: { edge in
            edge.origin == id || edge.destination == id
        }) {
            edges.remove(at: index)
        }
    }
    
    func neighbors(of node: Node) -> [Node] {
        let neighbors = structure[node.hashValue]?.map(\.destination).compactMap { nodeLookup[$0] } ?? []
        return neighbors
    }
}

struct DirectionalGraph<Node: Comparable & Hashable>: Graph {
    typealias Node = Node
    
    var nodes: Set<Node> = []
    var edges: Set<DirectionalEdge> = []
    
    internal var structure: [Int : Set<DirectionalEdge>] = [:]
    internal var nodeLookup: [Int : Node] = [:]
    
    mutating func addEdge(from origin: Node, to destination: Node) {
        addNode(origin)
        addNode(destination)
        
        nodeLookup[origin.hashValue] = origin
        nodeLookup[destination.hashValue] = destination
        
        let newEdge = DirectionalEdge(origin: origin.hashValue, destination: destination.hashValue)
        self.edges.insert(newEdge)
        self.structure[origin.hashValue]?.insert(newEdge)
    }
}

//struct WeightedGraph<WeightType: Comparable & Hashable>: Graph {
//    typealias NodeIDType = NodeID
//    typealias EdgeType = WeightedDirectionalEdge<NodeID, WeightType>
//
//    internal var structure: [NodeIDType : Set<EdgeType>] = [:]
//
//    mutating func addEdge(weight: WeightType, from origin: NodeIDType, to destination: NodeIDType, directional: Bool = true) {
//        if !structure.keys.contains(origin) {
//            structure[origin] = []
//        }
//
//        if !structure.keys.contains(destination) {
//            structure[destination] = []
//        }
//
//        let edge = EdgeType(weight: weight, origin: origin, destination: destination)
//        structure[origin]?.insert(edge)
//
//        if directional == false {
//            structure[destination]?.insert(edge.reversed())
//        }
//    }
//}
