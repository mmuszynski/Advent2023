//
//  Day18.swift
//  Advent2023Tests
//
//  Created by Mike Muszynski on 12/18/23.
//

import XCTest
@testable import Advent2023
import BundleURL
import Graph

final class Day18: XCTestCase {
    
    let input = #bundleURL("inputDay18")!
    let example = #bundleURL("exampleDay18")!
    
    func testMapRect() throws {
        let string = try String(contentsOf: example)
        let instructions = string.separatedByLine.map(DiggerInstruction.init)
        let rect = instructions.getMapRect()
        
        XCTAssertEqual(rect.origin, "0,0")
        XCTAssertEqual(rect.size, "7,10")
    }
    
    func testExampleGridFaster() throws {
        let string = try String(contentsOf: example)
        let instructions = string.separatedByLine.map(DiggerInstruction.init)

        
        XCTAssertEqual(instructions.shoelace(), 62)
    }
    
    func testInputGrid() throws {
        let string = try String(contentsOf: input)
        let instructions = string.separatedByLine.map(DiggerInstruction.init)
        
        XCTAssertEqual(instructions.shoelace(), 66993)
    }
    
    func testDayTwoInstruction() throws {
        let instructionString = "R 2 (#70c710)"
        let instruction = DiggerInstruction(string: instructionString)
        let two = instruction.partTwoInstruction
        XCTAssertEqual(two.direction, .right)
        XCTAssertEqual(two.length, 461937)
    }
    
    func testInputGridPartTwo() throws {
        let string = try String(contentsOf: input)
        let instructions = string.separatedByLine.map(DiggerInstruction.init).map(\.partTwoInstruction)
        
        XCTAssertEqual(instructions.shoelace(), 177243763226648)
    }
}
