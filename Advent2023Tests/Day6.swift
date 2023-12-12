//
//  Day6.swift
//  Advent2023Tests
//
//  Created by Mike Muszynski on 12/9/23.
//

import XCTest
@testable import Advent2023

final class Day6: XCTestCase {
    
    func processDay6Values(times: [Int], distances dists: [Int]) -> Int {
        var accum = 1
        for i in 0..<times.count {
            let solutions = Quadratic(a: -1, b: Double(times[i]), c: -Double(dists[i])).solutions.sorted()
            let floor = Int(floor(solutions.first!))
            let ceil = Int(ceil(solutions.last!))
            
            accum *= (ceil) - (floor + 1)
        }
        
        return accum
    }
    
    func testExampleDay6() throws {
        let input = try String(contentsOf: .exampleDay6).separatedByLine
        let times = input[0].components(separatedBy: .whitespaces).compactMap(Int.init)
        let dists = input[1].components(separatedBy: .whitespaces).compactMap(Int.init)
        
        XCTAssertEqual(processDay6Values(times: times, distances: dists), 288)
    }
    
    func testInputDay6() throws {
            let input = try String(contentsOf: .inputDay6).separatedByLine
            let times = input[0].components(separatedBy: .whitespaces).compactMap(Int.init)
            let dists = input[1].components(separatedBy: .whitespaces).compactMap(Int.init)
            
            XCTAssertEqual(processDay6Values(times: times, distances: dists), 2756160)
    }    
    
    func testExampleDay6Part2() throws {
        let input = try String(contentsOf: .exampleDay6).separatedByLine
        let times = [input[0]
            .components(separatedBy: ":")[1]
            .components(separatedBy: .whitespaces)
            .joined()]
            .compactMap(Int.init)
        let dists = [input[1]
            .components(separatedBy: ":")[1]
            .components(separatedBy: .whitespaces)
            .joined()]
            .compactMap(Int.init)
        
        XCTAssertEqual(processDay6Values(times: times, distances: dists), 71503)
    }
    
    func testInputDay6Part2() throws {
        let input = try String(contentsOf: .inputDay6).separatedByLine
        let times = [input[0]
            .components(separatedBy: ":")[1]
            .components(separatedBy: .whitespaces)
            .joined()]
            .compactMap(Int.init)
        let dists = [input[1]
            .components(separatedBy: ":")[1]
            .components(separatedBy: .whitespaces)
            .joined()]
            .compactMap(Int.init)
        
        XCTAssertEqual(processDay6Values(times: times, distances: dists), 34788142)
    }
    
    

}
