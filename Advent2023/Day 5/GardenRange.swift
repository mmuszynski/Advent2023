//
//  GardenRange.swift
//  Advent2023
//
//  Created by Mike Muszynski on 12/7/23.
//

import Foundation

struct GardenRange: Equatable, Hashable {
    @available(*, unavailable, renamed: "sourceRangeStart")
    private var initialValue: Int { fatalError() }
    private var sourceRangeStart: Int
    
    @available(*, unavailable, renamed: "destinationRangeStart")
    private var mappedValue: Int { fatalError() }
    private var destinationRangeStart: Int
    
    private var length: Int

    var mapAmount: Int {
        destinationRangeStart - sourceRangeStart
    }
    
    @available(*, unavailable, renamed: "sourceRange")
    var inputRange: Range<Int> {
        fatalError()
    }
    var sourceRange: Range<Int> {
        sourceRangeStart..<(sourceRangeStart.advanced(by: length))
    }
    
    @available(*, unavailable, renamed: "destinationRange")
    var outputRange: Range<Int> {
        destinationRangeStart..<(destinationRangeStart.advanced(by: length))
    }
    var destinationRange: Range<Int> {
        destinationRangeStart..<(destinationRangeStart.advanced(by: length))
    }
    
    var convertedToDestination: GardenRange {
        GardenRange(range: sourceRangeStart.advanced(by: mapAmount)..<sourceRangeStart.advanced(by: mapAmount).advanced(by: length))
    }
    
    func converting(_ inputValue: Int) -> Int? {
        guard sourceRange.contains(inputValue) else { return nil }
        
        let offset = inputValue - sourceRangeStart
        return destinationRangeStart + offset
    }
    
    init(string: String) {
        //50 98 2
        let numbers = string.components(separatedBy: .whitespaces).compactMap(Int.init)
        guard numbers.count == 3 else { fatalError(string) }
        sourceRangeStart = numbers[1]
        destinationRangeStart = numbers[0]
        length = numbers[2]
    }
    
    init(range: Range<Int>, map: Int = 0) {
        self.sourceRangeStart = range.lowerBound
        self.destinationRangeStart = range.lowerBound + map
        self.length = range.upperBound - range.lowerBound
    }
}

extension GardenRange {
    func combine(with other: GardenRange) -> [GardenRange] {
        let selfRange = self.sourceRange
        let otherRange = other.sourceRange
        
        var foundRange: GardenRange?
        
        let clamped = selfRange.clamped(to: otherRange)
        if !clamped.isEmpty {
            foundRange = GardenRange(range: clamped,
                                     map: other.destinationRangeStart - other.sourceRangeStart)
        }
        
        var otherRanges = [GardenRange]()
        otherRanges = selfRange.excluding(otherRange).compactMap { $0 }.map { GardenRange(range: $0) }

        return ([foundRange] + otherRanges).compactMap { $0 }
        
    }
}
