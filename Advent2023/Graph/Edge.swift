//
//  Edge.swift
//  Advent2023
//
//  Created by Mike Muszynski on 12/29/23.
//

import Foundation


/// Base protocol for Edges of a Graph
protocol Edge: Hashable, Equatable {
    //The origin node
    var origin: Int { get set }
    
    //The destination
    var destination: Int { get set }
    
    func reversed() -> Self
}

extension Edge {
    func reversed() -> Self {
        var new = self
        new.origin = self.destination
        new.destination = self.origin
        return new
    }
}

protocol WeightedEdge: Edge {
    associatedtype WeightType: Comparable
    var weight: WeightType { get }
}

struct DirectionalEdge: Edge {
    var origin: Int
    var destination: Int
}

struct BidirectionalEdge: Edge {
    var origin: Int
    var destination: Int
}

struct WeightedDirectionalEdge<W>: WeightedEdge where W: Hashable, W: Comparable{
    typealias WeightType = W
    var weight: WeightType
    
    var origin: Int
    var destination: Int
}

struct WeightedBidirectionalEdge<W>: WeightedEdge where W: Hashable, W: Comparable {
    typealias WeightType = W
    var weight: WeightType
    
    var origin: Int
    var destination: Int
}
