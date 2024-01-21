//
//  Day21.swift
//  Advent2023Tests
//
//  Created by Mike Muszynski on 1/15/24.
//

import XCTest
@testable import Advent2023
import BundleURL
import Coordinate

final class Day21: XCTestCase {
    
    let input = #bundleURL("inputDay21")!
    let example = #bundleURL("exampleDay21")!
 
    func testDay21Example() throws {
        let string = try String(contentsOf: example)
        let controller = GardenWalkController(string: string)
                
        XCTAssertEqual(controller.activeLocations.first, "5,5")
                
        controller.step()
        XCTAssertEqual(controller.activeLocations.count, 2)
        controller.step()
        XCTAssertEqual(controller.activeLocations.count, 4)
        controller.step()
        XCTAssertEqual(controller.activeLocations.count, 6)
        for _ in 1...3 {
            controller.step()
        }
        XCTAssertEqual(controller.activeLocations.count, 16)
    }
    
    func testDay21Input() throws {
        let string = try String(contentsOf: input)
        let controller = GardenWalkController(string: string)
        
        for _ in 1...(64) {
            controller.step()
        }
        XCTAssertEqual(controller.activeLocations.count, 3841)
    }
    
    func testDay21Part2() throws {
        let controller = try GardenWalkController(url: input)
        
        let start = controller.activeLocations.first!
        let field = controller.graph.directionField(start: start)
        
        var oddParity = Set<Coordinate>()
        var evenParity = Set<Coordinate>()
        var over65OddParity = Set<Coordinate>()
        var over65EvenParity = Set<Coordinate>()
        
        for coordinate in field.keys {
            var distance = 0
            var location = coordinate
            while let newLocation = field[location], newLocation != start {
                distance += 1
                location = newLocation
            }
            distance += 1
            
            if distance % 2 == 0 {
                evenParity.insert(coordinate)
                if distance > 65 {
                    over65EvenParity.insert(coordinate)
                }
            } else {
                oddParity.insert(coordinate)
                if distance > 65 {
                    over65OddParity.insert(coordinate)
                }
            }
        }

        
//        controller.activeLocations = ["65,0"]
//        controller.step(130)
//        let finalAxis1 = controller.activeLocations.count
//        
//        controller.activeLocations = ["65,130"]
//        controller.step(130)
//        let finalAxis2 = controller.activeLocations.count
//        
//        controller.activeLocations = ["0,65"]
//        controller.step(130)
//        let finalAxis3 = controller.activeLocations.count
//        
//        controller.activeLocations = ["130,65"]
//        controller.step(130)
//        let finalAxis4 = controller.activeLocations.count
//        
//        let lastAxes = finalAxis1 + finalAxis2 + finalAxis3 + finalAxis4
//        
//        let active: [Coordinate] = ["0,0", "0,130", "130,130", "130,0"]
//        let cornerOdd = active.map { start in
//            controller.activeLocations = [start]
//            controller.step(65)
//            return controller.activeLocations.count
//        }.sum
//        XCTAssertEqual(cornerOdd, 1013 + 1011 + 1014 + 1023)
//        
//        let cornerEven = active.map { start in
//            controller.activeLocations = [start]
//            controller.step(64)
//            return controller.activeLocations.count
//        }.sum
        
        let n = 202300
        let totalOdd = (n + 1) * (n + 1)
        let totalEven = n * n
        
        let oddCorners = n + 1
        let evenCorners = n
        
                
        //7806 odd parity
        //7744 even parity
        let totalActive = totalOdd * oddParity.count + totalEven * evenParity.count - oddCorners * over65OddParity.count + evenCorners * over65EvenParity.count

        XCTAssertEqual(totalActive, 636391426712747)
        XCTAssertLessThan(totalActive, 638935294936806)
        XCTAssertNotEqual(totalActive, 636391398390545)
        XCTAssertNotEqual(totalActive, 633850964752521)
        XCTAssertGreaterThan(totalActive, 633860584061944)
        //
        //638935294936806 - High
        //636397939499375
        //636391398390545 - incorrect
        // - incorrect
        //
        //633860584061944 - Low
        
        //let
        //corners / 4 * diagonalBlocks
    }
    
}
