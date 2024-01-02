//
//  NodeTests.swift
//  Advent2023Tests
//
//  Created by Mike Muszynski on 12/10/23.
//

import XCTest
@testable import Advent2023

final class Day8GraphVersionTests: XCTestCase {
    
//    RL
//
//    AAA = (BBB, CCC)
//    BBB = (DDD, EEE)
//    CCC = (ZZZ, GGG)
//    DDD = (DDD, DDD)
//    EEE = (EEE, EEE)
//    GGG = (GGG, GGG)
//    ZZZ = (ZZZ, ZZZ)

//    func testInitGraph() throws {
//        var lines = try String(contentsOf: .exampleDay8).separatedByLine
//        let instructions = lines.removeFirst()
//        var graph = WeightedGraph<String, String>()
//
//        for line in lines {
//            let nodes = line.components(separatedBy: .punctuationCharacters.union(.whitespaces).union(CharacterSet(charactersIn: "="))).filter { !$0.isEmpty }
//            graph.addEdge(weight: "left", from: nodes[0], to: nodes[1])
//            graph.addEdge(weight: "right", from: nodes[0], to: nodes[2])
//        }
//        
//    }

}
