//: [Previous](@previous)

import Foundation

var example = """
467..114..
...*......
..35..633.
......#...
617*......
.....+.58.
..592.....
......755.
...$.*....
.664.598..
"""

let fullString = try String(contentsOf: #fileLiteral(resourceName: "PuzzleInput3"))
var schematic = Schematic(string: fullString)

let symbolCharacters = Set(fullString.symbolCharacters.replacingOccurrences(of: ".", with: ""))
var accum = 0

schematic.partNumbers.count

schematic.markParts(nearSymbols: fullString.symbolCharacters.replacingOccurrences(of: ".", with: ""))
schematic.markedParts

var canvas = schematic.lines.map { String(repeating: ".", count: $0.count) }
for markedPart in schematic.markedParts {
    canvas[markedPart.start.y] = String(canvas[markedPart.start.y].enumerated().map { (markedPart.start.x...markedPart.end.x).contains($0.offset) ? "X" : "." })
}
print(canvas)

//let fullSchematic = Schematic(string: fullString)
//
//fullSchematic.getPortion(first: "8,-1", second: "10,0").joined(separator: "\n")
//
//
//
////: [Next](@next)
