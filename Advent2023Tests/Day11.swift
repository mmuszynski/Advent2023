//
//  Day10.swift
//  Advent2023Tests
//
//  Created by Mike Muszynski on 12/11/23.
//

import XCTest
import BundleURL
@testable import Advent2023

final class Day11: XCTestCase {
    
    let input = #bundleURL("inputDay11")!
    let example = #bundleURL("exampleDay11")!
    
    func testExampleDay11() throws {
        let string = try String(contentsOf: example)
        var universe = GalacticMap(string: string)
        
        print(universe.map)
        
        let emptyRows = universe.map.rowIndices(where: { row in
            row.allSatisfy { $0 == .empty }
        })
        
        XCTAssertEqual(emptyRows, [3,7])
        
        let emptyCols = universe.map.columnIndices(where: { col in
            col.allSatisfy { $0 == .empty }
        })
        XCTAssertEqual(emptyCols, [2, 5, 8])
        
        //universe = expand(universe: universe)
        
        //XCTAssertEqual(universe.map.rowCount, 12)
        //XCTAssertEqual(universe.map.columnCount, 13)
        
        //print(universe.map)
        
        XCTAssertEqual(sumDistances(for: universe), 374)
    }
    
    func emptyRows(for universe: GalacticMap) -> [Int] {
        let emptyRows = universe.map.rowIndices(where: { row in
            row.allSatisfy { $0 == .empty || $0 == .vastNothingness }
        })
        
        return emptyRows
    }
    
    func emptyColumns(for universe: GalacticMap) -> [Int] {
        let emptyCols = universe.map.columnIndices(where: { col in
            col.allSatisfy { $0 == .empty || $0 == .vastNothingness }
        })
        
        return emptyCols
    }
    
    func expand(universe: GalacticMap, expansionType: GalacticMap.GalacticContent = .empty) -> GalacticMap {
        var universe = universe
        
        for col in emptyColumns(for: universe).sorted().reversed() {
            universe.map.insertColumn(repeating: expansionType, at: col)
        }

        
        for row in emptyRows(for: universe).sorted().reversed() {
            universe.map.insertRow(repeating: expansionType, at: row)
        }
        
        return universe
    }
    
    func sumDistances(for universe: GalacticMap, vastDistance: Int = 1) -> Int {
        var galaxies = universe.galaxies
        
        let emptyRows = emptyRows(for: universe)
        let emptyColumns = emptyColumns(for: universe)
        
        var accum = 0
        while let galaxy = galaxies.popLast() {
            for other in galaxies {
                let x = [galaxy.x, other.x].sorted()
                let y = [galaxy.y, other.y].sorted()
                
                let xRange = x[0]..<x[1]
                let yRange = y[0]..<y[1]
                
                let totalX = xRange.upperBound - xRange.lowerBound
                let totalY = yRange.upperBound - yRange.lowerBound
                
                let vastX = emptyColumns.filter { xRange.contains($0) }.count
                let vastY = emptyRows.filter { yRange.contains($0) }.count
                
                //let distance = universe.distance(from: galaxy, to: other)
                let distance = totalX + totalY + (vastX + vastY) * vastDistance
                accum += distance
            }
        }
        return accum
    }
    
    func testInputDay11() throws {
        let string = try String(contentsOf: input)
        let universe = GalacticMap(string: string)
        
        XCTAssertEqual(sumDistances(for: universe), 9556712)
    }
    
    func testExampleDay11Part2() throws {
        let string = try String(contentsOf: example)
        let universe = GalacticMap(string: string)
            
        XCTAssertEqual(sumDistances(for: universe, vastDistance: 10 - 1), 1030)
        XCTAssertEqual(sumDistances(for: universe, vastDistance: 100 - 1), 8410)
    }
    
    func testInputDay11Part2() throws {
        let string = try String(contentsOf: input)
        let universe = GalacticMap(string: string)
        
        //print(universe.map)
        XCTAssertEqual(sumDistances(for: universe, vastDistance: 1000000-1), 678626199476)
    }
    
}
