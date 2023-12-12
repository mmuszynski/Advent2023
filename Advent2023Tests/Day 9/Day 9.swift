//
//  Day 9.swift
//  Advent2023Tests
//
//  Created by Mike Muszynski on 12/11/23.
//

import XCTest
import BundleURL
@testable import Advent2023

extension Array where Element == Int {
    var differenceSequence: [Int] {
        self.enumerated().reduce(into: []) { partialResult, current in
            let nextIndex = current.offset.advanced(by: 1)
            guard nextIndex < self.count else { return }
            partialResult.append(self[nextIndex] - current.element)
        }
    }
}

final class Day9: XCTestCase {

    let input = #bundleURL("inputDay9")!
    let example = #bundleURL("exampleDay9")!

    func intSequence(from string: String) -> [Int] {
        string.components(separatedBy: .whitespaces).compactMap(Int.init)
    }
    
    func testDifferenceSequence() throws {
        let sequence = [1, 2, 3, 4, 5, 6]
        XCTAssertEqual(sequence.differenceSequence, [1, 1, 1, 1, 1])
        
        XCTAssertEqual(allSequences(from: sequence), [sequence, [1, 1, 1, 1, 1], [0, 0, 0, 0]])
    }
    
    func allSequences(from sequence: [Int]) -> [[Int]] {
        var allSequences = [sequence]
        while !allSequences.last!.filter({ $0 != 0 }).isEmpty {
            allSequences.append(allSequences.last!.differenceSequence)
        }
        return allSequences
    }
    
    func summarize(sequences: [[Int]]) -> Int {
        sequences.compactMap(\.last).sum
    }
    
    func testExample1() throws {
        let lines = try String(contentsOf: self.example).separatedByLine
        
        XCTAssertEqual(lines.map(self.intSequence).map(self.allSequences).map(self.summarize).sum, 114)
    }
    
    func testInput1() throws {
        let lines = try String(contentsOf: self.input).separatedByLine
        let sequences = lines.map(self.intSequence)
        let history = sequences.map(self.allSequences)
        let summaries = history.map(self.summarize)
        
        XCTAssertEqual(summaries.sum, 2174807968)
    }
    
    func testExample2() throws {
        let lines = try String(contentsOf: self.example).separatedByLine
        let sequences = lines.map(self.intSequence)
        let histories = sequences.map(self.allSequences)

        let summaries = histories.map { history in
            history.reversed().reduce(0) { accum, next in
                next.first! - accum
            }
        }
        
        print(summaries)
        
        XCTAssertEqual(summaries.sum, 2)
    }
    
    func testInput2() throws {
        let lines = try String(contentsOf: self.input).separatedByLine
        let sequences = lines.map(self.intSequence)
        let histories = sequences.map(self.allSequences)

        let summaries = histories.map { history in
            history.reversed().reduce(0) { accum, next in
                print(next.first! - accum)
                print("\(next.first!) - \(accum)")
                return next.first! - accum
            }
        }
    
        XCTAssertEqual(summaries.sum, 1208)
    }
    
    
}
