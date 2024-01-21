//
//  Schematic.swift
//  Advent2023
//
//  Created by Mike Muszynski on 12/4/23.
//

import Foundation
import Coordinate

extension String {
    public var symbolCharacters: String {
        var output = String()
        let set = "0123456789"
        for char in self.components(separatedBy: .newlines).joined() {
            if !set.contains(char) {
                output.append(char)
            }
        }
        return output
    }
}

public struct PartNumber: Hashable {
    public var value: Int
    public var start: Coordinate
    public var end: Coordinate
    
    func isAdjacent(to coordinate: Coordinate) -> Bool {        
        let xRange = (start.x - 1)...(end.x + 1)
        let yRange = (start.y - 1)...(end.y + 1)
        
        return xRange.contains(coordinate.x) && yRange.contains(coordinate.y)
    }
}

public struct Symbol: Hashable {
    public var type: String
    public var location: Coordinate
}

public struct Schematic {
    public var lines: [String]
    public var partNumbers: [PartNumber] = []
    public var markedParts: [PartNumber] = []
    
    public var symbols: [Symbol] = []
    
    public var gears: [Symbol] {
        symbols.filter { $0.type == "*" }
    }
    
    public func getPortion(first: Coordinate, second: Coordinate) -> [String] {
        precondition(first.x <= second.x)
        precondition(first.y <= second.y)
        
        var returnLines = lines[max(first.y, 0)...min(second.y, lines.count - 1)]
        
        //what if it's out of bounds?
        if first.y < 0 {
            var y = first.y
            while y < 0 {
                returnLines.insert(String(repeating: ".", count: returnLines.first?.count ?? 0), at: 0)
                y += 1
            }
        }
        
        var y = second.y
        while y >= lines.count {
            returnLines.append(String(repeating: ".", count: returnLines.first?.count ?? 0))
            y -= 1
        }
        
        return returnLines.map { string in
            var firstIndex = first.x
            var frontAppend = ""
            while firstIndex < 0 {
                firstIndex += 1
                frontAppend.append(".")
            }
            
            var lastIndex = second.x
            var backAppend = ""
            while lastIndex >= string.count {
                backAppend.append(".")
                lastIndex -= 1
            }
            
            let startIndex = string.index(string.startIndex, offsetBy: firstIndex)
            let endIndex = string.index(string.startIndex, offsetBy: lastIndex)
                        
            return frontAppend + String(string[startIndex...endIndex]) + backAppend
        }
    }
    
    public init(string: String) {
        lines = string.components(separatedBy: .newlines).filter { !$0.isEmpty }
        let symbols = string.symbolCharacters

        for (row, line) in lines.enumerated() {
            var location: Coordinate?
            var accum: String = ""
            
            for (col, char) in line.enumerated() {
                
                if !symbols.contains(char) {
                    //this is a number
                    if location == nil {
                        location = Coordinate(x: col, y: row)
                    }
                    accum.append(char)
                } else {
                    //this is a symbol
                    if char != "." {
                        self.symbols.append(Symbol(type: String(char), location: Coordinate(x: col, y: row)))
                    }
                    
                    if location != nil {
                        //finalize part number
                        let start = location!
                        var end = location!
                        end.x = col - 1
                        guard let value = Int(accum) else { fatalError("line") }
                        
                        partNumbers.append(PartNumber(value: value, start: start, end: end))
                        
                        location = nil
                        accum = ""
                    }
                }
            }
            
            //end of line reached, finalize part number
            if location != nil {
                //finalize part number
                let start = location!
                var end = location!
                end.x = line.lengthOfBytes(using: .utf8) - 1
                guard let value = Int(accum) else { fatalError("line") }
                
                partNumbers.append(PartNumber(value: value, start: start, end: end))
                
                location = nil
                accum = ""
            }
        }
        
        
    }
    
    public mutating func markParts(nearSymbols symbols: String) {
        let symbolCharacters = Set(symbols)
        for (index, part) in self.partNumbers.enumerated() {
            print("part \(index)...")
            print(part)
            
            let portion = self.getPortion(first: part.start.advancing(x: -1, y: -1), second: part.end.advancing(x: 1, y: 1)).joined(separator: "\n")

            if !Set(portion).intersection(symbolCharacters).isEmpty {
                //print("===YES===")
                markedParts.append(part)
            } else {
                //print("===NO====")
            }
            
            //print(portion)
        }
        
        print("done")
    }
}
