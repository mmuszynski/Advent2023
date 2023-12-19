//
//  Day6.swift
//  Advent2023Tests
//
//  Created by Mike Muszynski on 12/18/23.
//

import XCTest
@testable import Advent2023
import BundleURL

let input = #bundleURL("inputDay15")!
let example = #bundleURL("exampleDay15")!

extension String {
    var reindeerHash: Int {
        var value = 0
        for char in self {
            guard let ascii = char.asciiValue else { fatalError("\(char)") }
            value += Int(ascii)
            value *= 17
            value = value % 256
        }
        return value
    }
    
    var lensLabel: String {
        let labelText = self
            .components(separatedBy: "=")[0]
            .components(separatedBy: "-")[0]
        return labelText
    }
    
    var lensLabelHash: Int {
        return lensLabel.reindeerHash
    }
}

struct Lens {
    var label: String
    var focalLength: Int
}

extension Array where Element == Lens {
    func score(box: Int) -> Int {
        self.enumerated().map { (offset, lens) in
            return (box + 1) * (offset + 1) * lens.focalLength
        }.sum
    }
}

final class Day15: XCTestCase {
    
    func testHash() {
        let string = "HASH"
        XCTAssertEqual(string.reindeerHash, 52)
    }
    
    func testExamplePart1() throws {
        let string = try String(contentsOf: example).replacingOccurrences(of: "\n", with: "")
        let components = string.components(separatedBy: ",").filter { !$0.isEmpty }
        
        XCTAssertEqual("rn=1".reindeerHash, 30)
        XCTAssertEqual("cm-".reindeerHash, 253)
        XCTAssertEqual("qp=3".reindeerHash, 97)
        XCTAssertEqual("cm=2".reindeerHash, 47)
        XCTAssertEqual("qp-".reindeerHash, 14)
        XCTAssertEqual("pc=4".reindeerHash, 180)
        XCTAssertEqual("ot=9".reindeerHash, 9)
        XCTAssertEqual("ab=5".reindeerHash, 197)
        XCTAssertEqual("pc-".reindeerHash, 48)
        XCTAssertEqual("pc=6".reindeerHash, 214)
        XCTAssertEqual("ot=7".reindeerHash, 231)

        XCTAssertEqual(components.count, 11)
        let hashes = components.map { $0.reindeerHash }
        
        XCTAssertEqual(hashes.sum, 1320)
    }
    
    func testInputPart1() throws {
        let string = try String(contentsOf: input).replacingOccurrences(of: "\n", with: "")
        let components = string.components(separatedBy: ",").filter { !$0.isEmpty }
        
        let hashes = components.map { $0.reindeerHash }
        
        XCTAssertEqual(hashes.sum, 498538)
    }
    
    func calculate(using instructions: [String]) -> Int {
        var boxes: [[Lens]] = Array(repeating: [Lens](), count: 256)
        
        for instruction in instructions {
            guard let number = instruction.last else { fatalError(instruction) }
            
            let labelHash = instruction.lensLabelHash
            let label = instruction.lensLabel
            
            var box = boxes[labelHash]
            
            if instruction.contains("-") {
                if let index = box.firstIndex(where: { $0.label == label }) {
                    box.remove(at: index)
                }
            } else if instruction.contains("=") {
                guard let focalLength = Int(String(number)) else { fatalError("\(number)") }
                let lens = Lens(label: label, focalLength: focalLength)

                if let index = box.firstIndex(where: { $0.label == label }) {
                    box[index] = lens
                } else {
                    box.append(lens)
                }
            }
            
            boxes[labelHash] = box

        }
        
        return boxes.enumerated().map { $1.score(box: $0)}.sum
    }
    
    func testExamplePart2() throws {
        let string = try String(contentsOf: example).replacingOccurrences(of: "\n", with: "")
        let instructions = string.components(separatedBy: ",").filter { !$0.isEmpty }

        XCTAssertEqual("rn=1".lensLabelHash, 0)
        XCTAssertEqual("qp=3".lensLabelHash, 1)
        
        XCTAssertEqual(calculate(using: instructions), 145)
    }
    
    func testInputPart2() throws {
        let string = try String(contentsOf: input).replacingOccurrences(of: "\n", with: "")
        let instructions = string.components(separatedBy: ",").filter { !$0.isEmpty }
        
        XCTAssertEqual(calculate(using: instructions), 286278)
    }
}
