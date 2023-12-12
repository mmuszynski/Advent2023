//
//  NodeTests.swift
//  Advent2023Tests
//
//  Created by Mike Muszynski on 12/10/23.
//

import XCTest
@testable import Advent2023

final class Day8: XCTestCase {
    
    func setupNodes(from lines: [String]) -> [String : Node] {
        let nodes = lines.map(Node.init)
        let nodeDict = nodes.reduce(into: [String: Node]()) { partialResult, node in
            partialResult[node.name] = node
        }
        return nodeDict
    }
    
    func countNodes(in nodeDict: [String : Node], with instructions: String, starting: [Node] = []) -> Int {
        var currentNodes = starting
        var moveCount = 0
        
        while !currentNodes.filter({ $0.name.last != "Z" }).isEmpty {
            for instruction in instructions {
                switch instruction {
                case "R":
                    currentNodes = currentNodes.compactMap { nodeDict[$0.rightExit] }
                default:
                    currentNodes = currentNodes.compactMap { nodeDict[$0.leftExit] }
                }
                moveCount += 1
                if currentNodes.filter({ $0.name.last != "Z" }).isEmpty { break }
            }
        }
        
        return moveCount
    }

    func testDay8Example1A() throws {
        var lines = try String(contentsOf: .exampleDay8).separatedByLine
        let instructions = lines.removeFirst()
        let nodeDict = setupNodes(from: lines)
        let count = countNodes(in: nodeDict, with: instructions, starting: [nodeDict["AAA"]!])
        XCTAssertEqual(count, 2)
    }
    
    func testDay8Example1B() throws {
        var lines = try String(contentsOf: .exampleDay8_2).separatedByLine
        let instructions = lines.removeFirst()
        let nodeDict = setupNodes(from: lines)
        let count = countNodes(in: nodeDict, with: instructions, starting: nodeDict.filter({ $0.key.last == "A" }).map(\.value))
        XCTAssertEqual(count, 6)
    }
    
    func testDay8Input() throws {
        var lines = try String(contentsOf: .inputDay8).separatedByLine
        let instructions = lines.removeFirst()
        let nodeDict = setupNodes(from: lines)
        let count = countNodes(in: nodeDict, with: instructions, starting: [nodeDict["AAA"]!])
        XCTAssertEqual(count, 13939)
    }
    
    func testDay8Example2() throws {
        var lines = try String(contentsOf: .exampleDay8_3).separatedByLine
        let instructions = lines.removeFirst()
        let nodeDict = setupNodes(from: lines)
        let start: [Node] = nodeDict.filter({ $0.key.last == "A" }).map(\.value)
        let count = countNodes(in: nodeDict, with: instructions, starting: start)
        XCTAssertEqual(count, 6)
    }
    
    func testDay8Input2() throws {
        var lines = try String(contentsOf: .inputDay8).separatedByLine
        let instructions = lines.removeFirst()
        let nodeDict = setupNodes(from: lines)
        let starts: [Node] = nodeDict.filter({ $0.key.last == "A" }).map(\.value)
        var accum = 1
        for start in starts {
            let count = countNodes(in: nodeDict, with: instructions, starting: [start])
            print(count)
            //get lcm
            //8906539031197
            accum = LCM(accum, count)
        }
        XCTAssertEqual(accum, 8906539031197)
        //XCTAssertEqual(count, 13939)
    }
    
    func testGCD() throws {
        XCTAssertEqual(GCD(192, 270), 6)
        XCTAssertEqual(LCM(4, 6), 12)
        XCTAssertEqual(LCM(6, 4), 12)
    }
    
    func LCM(_ a: Int, _ b: Int) -> Int {
        abs(a * b) / GCD(a, b)
    }
    
    func GCD(_ a: Int, _ b: Int) -> Int {
        if a == 0 { return b }
        if b == 0 { return a }
        
        //A = B * Q + R
        return GCD(b, a % b)
    }
    
}
