//
//  Advent2023Tests.swift
//  Advent2023Tests
//
//  Created by Mike Muszynski on 12/4/23.
//

import XCTest
@testable import Advent2023

final class Advent2023Tests: XCTestCase {

//    func testDay3() throws {
//
//        let fullString = try String(contentsOf: .day3Input)
//        var schematic = Schematic(string: fullString)
//
//        let symbolCharacters = Set(fullString.symbolCharacters.replacingOccurrences(of: ".", with: ""))
//
//        schematic.markParts(nearSymbols: fullString.symbolCharacters.replacingOccurrences(of: ".", with: ""))
//        print(schematic.markedParts.map(\.value).sum)
//
//        var accum = 0
//
//        for gear in schematic.gears {
//            let adjacent = schematic.partNumbers
//                .filter { $0.isAdjacent(to: gear.location) }
//            if adjacent.count == 2 {
//                accum += adjacent.map(\.value).product
//            }
//        }
//        print(accum)
//
//
////        var canvas = schematic.lines.map { String(repeating: ".", count: $0.count) }
////        for markedPart in schematic.markedParts {
////            canvas[markedPart.start.y] = String(canvas[markedPart.start.y].enumerated().map { (markedPart.start.x...markedPart.end.x).contains($0.offset) ? "X" : "." })
////        }
////        print(canvas)
//
//        //let fullSchematic = Schematic(string: fullString)
//        //
//        //fullSchematic.getPortion(first: "8,-1", second: "10,0").joined(separator: "\n")
//        //
//        //
//        //
//        ////: [Next](@next)
//
//    }
    
    func day4Cards(from string: String) -> [ScratchCard] {
        var cards = [ScratchCard]()
        for line in string.separatedByLine {
            cards.append(ScratchCard(string: line))
        }
        return cards
    }
    
    func testDay4Example() throws {
        let cards = day4Cards(from: try String(contentsOf: .exampleDay4))
        XCTAssertEqual(cards.map(\.score).sum, 13)
    }
    
    func testDay4Part1() throws {
        let string = try String(contentsOf: .inputDay4)
        let cards = day4Cards(from: string)
        XCTAssertEqual(cards.map(\.score).sum, 25651)
    }
    
    func processCardsForDay4Part2(_ cards: [ScratchCard]) -> Int {
        let scores = cards.map(\.wins)
        var numCards = Array(repeating: 1, count: scores.count)
        
        for (index, score) in scores.enumerated() {
            for _ in 0..<numCards[index] {
                if score == 0 { continue }
                for advance in 1...score {
                    let nextIndex = index.advanced(by: advance)
                    numCards[nextIndex] += 1
                }
            }
        }
        
        return numCards.sum
    }

    func testDay4Part2Example() throws {
        let cards = day4Cards(from: try String(contentsOf: .exampleDay4))
        XCTAssertEqual(processCardsForDay4Part2(cards), 30)
    }
    
    func testDay4Part2() throws {
        let cards = day4Cards(from: try String(contentsOf: .inputDay4))
        XCTAssertEqual(processCardsForDay4Part2(cards), 19499881)
    }
}
