//
//  Day20.swift
//  Advent2023Tests
//
//  Created by Mike Muszynski on 12/19/23.
//

import XCTest
@testable import Advent2023
import BundleURL

final class Day20: XCTestCase {
    
    let input = #bundleURL("inputDay20")!
    let example = #bundleURL("exampleDay20")!
 
    func testDay20Example() {
        let controller = PulseModuleController.example
        controller.debug = false
        
        for _ in 0..<1000 {
            controller.send(.low, to: "broadcaster")
        }
        XCTAssertEqual(controller.lowPulses, 8000)
        XCTAssertEqual(controller.highPulses, 4000)
        XCTAssertEqual(controller.highPulses * controller.lowPulses, 32000000)
    }
    
    func testDay20Example2() {
        let controller = PulseModuleController.example2
        controller.debug = false
        
        for _ in 0..<1000 {
            controller.send(.low, to: "broadcaster")
        }
        XCTAssertEqual(controller.lowPulses, 4250)
        XCTAssertEqual(controller.highPulses, 2750)
        XCTAssertEqual(controller.highPulses * controller.lowPulses, 11687500)
    }
    
    func testInit() throws {
        let example = try String(contentsOf: example)
        let controller = PulseModuleController(string: example)
        let exampleController = PulseModuleController.example
        
        for _ in 0..<1000 {
            controller.send(.low, to: "broadcaster")
            exampleController.send(.low, to: "broadcaster")
        }

        XCTAssertEqual(controller.highPulses * controller.lowPulses,
                       exampleController.highPulses * exampleController.lowPulses)
    }
    
    func testInput() throws {
        let input = try String(contentsOf: input)
        let controller = PulseModuleController(string: input)
        for _ in 0..<1000 {
            controller.send(.low, to: "broadcaster")
        }
        
        XCTAssertEqual(controller.lowPulses * controller.highPulses, 763500168)
    }
    
    func testInputPart2() throws {
        let input = try String(contentsOf: input)
        let controller = PulseModuleController(string: input)
        
        var presses = 0
        
        var pressNums: [String: Int] = [:]
        controller.listener = { string, int in
            if pressNums[string] == nil {
                pressNums[string] = int
            }
        }
        
        while pressNums.count < 4 {
            presses += 1
            controller.presses = presses
            controller.send(.low, to: "broadcaster")
        }
        
        let value = pressNums.values.reduce(1) { partialResult, value in
            LCM(partialResult, value)
        }
        XCTAssertEqual(value, 0)
    }
}
