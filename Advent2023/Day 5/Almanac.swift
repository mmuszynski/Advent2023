//
//  Almanac.swift
//  Advent2023
//
//  Created by Mike Muszynski on 12/7/23.
//

import Foundation

struct Almanac {
    var seeds: [Int] = []
    var seedRanges: [GardenRange] = []
    
    var seedToSoil: [GardenRange] = []
    var soilToFertilizer: [GardenRange] = []
    var fertilizerToWater: [GardenRange] = []
    var waterToLight: [GardenRange] = []
    var lightToTemperature: [GardenRange] = []
    var temperatureToHumidity: [GardenRange] = []
    var humidityToLocation: [GardenRange] = []
    
    static func getHeaders(from string: String) -> [String] {
        let headers = string.separatedByLine.filter { line in
            var line = line
            line.removeAll { char in
                Set<Character>("0123456789 ").contains(char)
            }
            return !line.isEmpty
        }
            .compactMap { $0.components(separatedBy: ":").first }
        return headers
    }
    
    init(string: String, part: Int = 1) {
        let lines = string.separatedByLine
        let headers = Almanac.getHeaders(from: string)
        var header: String = "seeds"
        
        for line in lines {
            if let newHeader = headers.first(where: { line.contains($0) }) {
                header = newHeader
            }
            
            if header != "seeds" && line.contains(header) { continue }
            
            switch header {
            case "seeds":
                if part == 1 {
                    self.seeds = line.components(separatedBy: ":")[1].components(separatedBy: .whitespaces).compactMap(Int.init)
                } else {
                    let values = line.components(separatedBy: .whitespaces)
                    for (left, right) in stride(from: 1, to: values.count - 1, by: 2)
                        .lazy
                        .map( { (Int(values[$0]), Int(values[$0+1])) } ) {
                        
                        self.seedRanges.append(GardenRange(range: left!..<left!.advanced(by: right!)))
                    }
                    
                }
            case "seed-to-soil map":
                seedToSoil.append(GardenRange(string: line))
            case "soil-to-fertilizer map":
                soilToFertilizer.append(GardenRange(string: line))
            case "fertilizer-to-water map":
                fertilizerToWater.append(GardenRange(string: line))
            case "water-to-light map":
                waterToLight.append(GardenRange(string: line))
            case "light-to-temperature map":
                lightToTemperature.append(GardenRange(string: line))
            case "temperature-to-humidity map":
                temperatureToHumidity.append(GardenRange(string: line))
            case "humidity-to-location map":
                humidityToLocation.append(GardenRange(string: line))
            default:
                fatalError()
            }
            
        }
    }
    
    func getLocationFor(seed: Int) -> Int {
//        var seedToSoil: [GardenRange] = []
//        var soilToFertilizer: [GardenRange] = []
//        var fertilizerToWater: [GardenRange] = []
//        var waterToLight: [GardenRange] = []
//        var lightToTemperature: [GardenRange] = []
//        var temperatureToHumidity: [GardenRange] = []
//        var humidityToLocation: [GardenRange] = []
        
        //print("=========seed \(seed)===========")
        
        let location = seed
            .convert(using: seedToSoil)
            .convert(using: soilToFertilizer)
            .convert(using: fertilizerToWater)
            .convert(using: waterToLight)
            .convert(using: lightToTemperature)
            .convert(using: temperatureToHumidity)
            .convert(using: humidityToLocation) 
        
        return location
    }
}

extension Int {
    fileprivate func convert(using conversion: [GardenRange]) -> Int {
        let output = conversion.compactMap { $0.converting(self) }.first ?? self
        //print("\(self) --> \(output)")
        return output
    }
}
