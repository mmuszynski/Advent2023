//
//  Day5.swift
//  Advent2023Tests
//
//  Created by Mike Muszynski on 12/7/23.
//

import XCTest
@testable import Advent2023

final class Day5: XCTestCase {
    
    func testGardenRange() throws {
        let rangeString = "50 98 2"
        let range = GardenRange(string: rangeString)
        
        XCTAssertEqual(range.converting(99), 51)
        XCTAssertEqual(range.converting(52), nil)
    }
    
    func testAlmanacHeaders() throws {
        let string = try String(contentsOf: .exampleDay5)
        XCTAssertEqual(Almanac.getHeaders(from: string).count, 8)
    }
    
    func testDay5Part1Example() throws {
        let string = try String(contentsOf: .exampleDay5)
        let almanac = Almanac(string: string)
        XCTAssertEqual(almanac.seeds.count, 4)
        XCTAssertEqual(almanac.seedToSoil.count, 2)
        
        guard let min = almanac.seeds.map({ almanac.getLocationFor(seed: $0) }).min() else { fatalError() }
        
        XCTAssertEqual(min , 35)
    }
    
    func testDay5Part1() throws {
        let inputString = try String(contentsOf: .inputDay5)
        let input = Almanac(string: inputString)
        guard let answer = input.seeds.map({ input.getLocationFor(seed: $0) }).min() else { fatalError() }
        print(answer)
        
        XCTAssertNotNil(answer)
    }
    
    var debug = false
    
    func map(_ inputRanges: Array<GardenRange>, to outputRanges: Array<GardenRange>) -> Array<GardenRange> {
        if debug {
            print("=====input=====")
            print(inputRanges.map(\.sourceRange))
            print("=====output=====")
            print(outputRanges.map(\.sourceRange))
        }
        
        if outputRanges.isEmpty { return inputRanges }
        
        var outputRanges = outputRanges
        var output: Array<GardenRange> = []
        
        if let outputRange = outputRanges.popLast() {
            for inputRange in inputRanges {
                
                let clamped = inputRange.sourceRange.clamped(to: outputRange.sourceRange)
                if !clamped.isEmpty {
                    output.append(GardenRange(range: clamped, map: outputRange.mapAmount))
                }
                
                let ranges = inputRange.sourceRange.excluding(outputRange.sourceRange)
                
                let unused = ranges.map { GardenRange(range: $0) }
                output.append(contentsOf: map(unused, to: outputRanges))
            }
        }
        
        return output
    }
    
    func testMapInputRangesEmpty() throws {
        let inputRanges = [79..<93].map { GardenRange(range: $0) }
        let mapRanges: [GardenRange] = []
        
        let outputRanges = map(inputRanges, to: mapRanges)
        XCTAssertEqual(outputRanges.count, 1)
        XCTAssertEqual(outputRanges, inputRanges)
    }
    
    func testMapInputRangesTrivial() throws {
        let inputRanges = [79..<93].map { GardenRange(range: $0) }
        let mapRanges: [GardenRange] = [GardenRange(range: 0..<78)]
        
        let outputRanges = map(inputRanges, to: mapRanges)
        XCTAssertEqual(outputRanges.count, 1)
        XCTAssertEqual(outputRanges, inputRanges)
    }
    
    func testMapInputRangesTrivialWithTwoRanges() throws {
        let inputRanges = [79..<93].map { GardenRange(range: $0) }
        let mapRanges: [GardenRange] = [
            GardenRange(range: 0..<50),
            GardenRange(range: 50..<78)
        ]
        
        let outputRanges = map(inputRanges, to: mapRanges)
        
        XCTAssertEqual(outputRanges.count, 1)
        XCTAssertEqual(outputRanges, inputRanges)
    }
    
    func testMapInputRanges() throws {
        let inputRanges = [79..<93, ].map { GardenRange(range: $0) }
        let mapRanges = [
            GardenRange(range: 0..<37, map: 15),
            GardenRange(range: 37..<39, map: 15),
            GardenRange(range: 39..<54, map: -39)
        ]
        
        let outputRanges = map(inputRanges, to: mapRanges)
        
        XCTAssertEqual(outputRanges.count, 1)
        XCTAssertEqual(outputRanges, inputRanges)
    }
    
    func getMin(for almanac: Almanac) -> Int {
        let soilRanges = map(almanac.seedRanges, to: almanac.seedToSoil).map(\.convertedToDestination)
        let fertRanges = map(soilRanges, to: almanac.soilToFertilizer).map(\.convertedToDestination)
        let waterRanges = map(fertRanges, to: almanac.fertilizerToWater).map(\.convertedToDestination)
        let lightRanges = map(waterRanges, to: almanac.waterToLight).map(\.convertedToDestination)
        let tempRanges = map(lightRanges, to: almanac.lightToTemperature).map(\.convertedToDestination)
        let humidRanges = map(tempRanges, to: almanac.temperatureToHumidity).map(\.convertedToDestination)
        let locationRanges = map(humidRanges, to: almanac.humidityToLocation).map(\.convertedToDestination)
        
        let min = locationRanges.min { a, b in
            a.sourceRange.lowerBound < b.sourceRange.lowerBound
        }
        
        return min!.sourceRange.lowerBound
    }
    
    func testDay5Part3Example() throws {
        let string = try String(contentsOf: .exampleDay5)
        let almanac = Almanac(string: string, part: 2)
        
        XCTAssertEqual(getMin(for: almanac), 46)
    }
    
    func testDay5Part2() throws {
        let string = try String(contentsOf: .inputDay5)
        let almanac = Almanac(string: string, part: 2)
        
        XCTAssertEqual(getMin(for: almanac), 79874951)
    }
    
}
