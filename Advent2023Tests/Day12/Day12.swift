//
//  Day10.swift
//  Advent2023Tests
//
//  Created by Mike Muszynski on 12/11/23.
//

import XCTest
import BundleURL
@testable import Advent2023

final class Day12: XCTestCase {
    
    let input = #bundleURL("inputDay12")!
    let example = #bundleURL("exampleDay12")!
    
    var calculator: SpringMapCalculator = SpringMapCalculator()
    
//    func testNaiveExampleDay12() throws {
//        let string = try String(contentsOf: example).separatedByLine
//        
//        let maps = string
//            .map(SpringMap.init)
//            .map(\.validCombinations)
//        
//        XCTAssertEqual(maps.map(\.count).sum, 21)
//    }
    
    func testCountNoneAvailable() {
        XCTAssertEqual(calculator.count("#?", blocks: [3]), 0)
        XCTAssertEqual(calculator.count("#", blocks: [2]), 0)
        XCTAssertEqual(calculator.count(".", blocks: [1]), 0)
        XCTAssertEqual(calculator.count(".", blocks: [1,1]), 0)
        XCTAssertEqual(calculator.count(".#", blocks: [1,1]), 0)
        XCTAssertEqual(calculator.count(".#.", blocks: [1,1]), 0)
        XCTAssertEqual(calculator.count("?#.", blocks: [1,1]), 0)
    }
    
    func testCountNoneAvailableFails() {
        XCTAssertEqual(calculator.count(".#?", blocks: [1,1]), 0)
    }
    
    func testAmbiguousFirstCharacter() {
        XCTAssertEqual(calculator.count("????", blocks: [1]), 4)
    }
    
    func testCountExampleFailures() {
        XCTAssertEqual(calculator.count(".??..??...?##.", blocks: [1,1,3]), 4)
    }
    
    func testExampleDay12Count() throws {
        let string = try String(contentsOf: example).separatedByLine
        
        let maps = string
            .map(SpringMap.init)
            .map( { calculator.count($0.status, blocks: $0.groups) })
                
        XCTAssertEqual(maps.sum, 21)
    }
    
    func testInputDay12() throws {
        let string = try String(contentsOf: input).separatedByLine
        
        let maps = string
            .map(SpringMap.init)
            .map( { calculator.count($0.status, blocks: $0.groups) })
        
        XCTAssertEqual(maps.sum, 7307)
    }
    
    func testExpandedExampleDay12() throws {
        let string = try String(contentsOf: example).separatedByLine
        
        let maps = string
            .map { string in
                let comps = string.components(separatedBy: .whitespaces).enumerated().map { (offset, string) in
                    var output = ""
                    for _ in 0..<5 {
                        output.append(string)
                        output.append(offset == 1 ? "," : "?")
                    }
                    return output.dropLast()
                }
                
                return String(comps.joined(separator: " "))
            }
            .sorted(by: { $0.lengthOfBytes(using: .utf8) < $1.lengthOfBytes(using: .utf8) })
            .map(SpringMap.init)
            .map( { calculator.count($0.status, blocks: $0.groups) })
                
        XCTAssertEqual(maps.sum, 525152)
    }
    
    func testExpandedInputDay12() throws {
        #warning("This test takes 20+ seconds")
        let string = try String(contentsOf: input).separatedByLine
        
        let maps = string
            .map { string in
                let comps = string.components(separatedBy: .whitespaces).enumerated().map { (offset, string) in
                    var output = ""
                    for _ in 0..<5 {
                        output.append(string)
                        output.append(offset == 1 ? "," : "?")
                    }
                    return output.dropLast()
                }
                
                return String(comps.joined(separator: " "))
            }
            .sorted(by: { $0.lengthOfBytes(using: .utf8) < $1.lengthOfBytes(using: .utf8) })
            .map(SpringMap.init)
            .map( { calculator.count($0.status, blocks: $0.groups) })
                
        XCTAssertEqual(maps.sum, 3415570893842)
    }
}
