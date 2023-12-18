//
//  SpringMap.swift
//  Advent2023
//
//  Created by Mike Muszynski on 12/13/23.
//

import Foundation
import Algorithms

struct SpringMap {
    enum Status: Character, ExpressibleByStringLiteral {
        case operational = "#"
        case broken = "."
        case unknown = "?"
        
        init(stringLiteral value: StringLiteralType) {
            self.init(rawValue: value.first!)!
        }
    }
    
    var status: SpringStatusRow
    var groups: [Int]
    
    init(string: String) {
        let comps = string.components(separatedBy: .whitespaces)
        let status = SpringStatusRow(string: comps[0])
        let groups = comps[1].components(separatedBy: ",").compactMap(Int.init)
        
        self.status = status
        self.groups = groups        
    }
    
    var validCombinations: [SpringStatusRow] {
        status.allCombinations.filter { $0.satsfies(groups) }
    }
}

struct SpringStatusRow {
    typealias Element = SpringMap.Status
    private var elements: [Element] = []
    
    init(_ statusArray: [Element]) {
        elements = statusArray
    }
    
    init(string: String) {
        elements = string.compactMap { char in
            return SpringMap.Status(rawValue: char)
        }
        assert(elements.count == string.lengthOfBytes(using: .utf8))
    }
    
    func satsfies(_ groups: [Int]) -> Bool {
        self.description.components(separatedBy: ".").map(\.count).filter({$0 != 0}) == groups
    }
    
    var allCombinations: [SpringStatusRow] {
        let unknowns = self.enumerated().filter { $0.element == .unknown }.map(\.offset)
        var combinations = [SpringStatusRow]()
        
        guard self.contains(.unknown) else { return [self] }
        
        for count in 0..<unknowns.count+1 {
            for combination in unknowns.combinations(ofCount: count) {
                combinations.append(
                    SpringStatusRow(self.enumerated().map { (offset, status) in
                        if status == .unknown {
                            return combination.contains(offset) ? SpringMap.Status.operational : .broken
                        }
                        return status
                    })
                )
                
            }
        }
        
        return combinations
    }
}

extension SpringStatusRow: Collection {
    func index(after i: Array<Element>.Index) -> Array<Element>.Index {
        self.elements.index(after: i)
    }
    
    var startIndex: Array<Element>.Index {
        self.elements.startIndex
    }
    
    var endIndex: Array<Element>.Index {
        self.elements.endIndex
    }
    
    subscript(position: Int) -> SpringMap.Status {
        return elements[position]
    }
    
    subscript(bounds: Range<Int>) -> Slice<SpringStatusRow> {
        return Slice<SpringStatusRow>(base: self, bounds: bounds)
    }
    
    init(_ slice: Slice<SpringStatusRow>) {
        self.elements = Array(slice.lazy.elements)
    }
}

extension SpringStatusRow: ExpressibleByStringLiteral {
    init(stringLiteral: String) {
        self.init(string: stringLiteral)
    }
}

extension SpringStatusRow: Equatable {}

extension SpringStatusRow: CustomStringConvertible {
    var description: String {
        self.map(\.rawValue).map(String.init).joined()
    }
}

extension SpringStatusRow: RangeReplaceableCollection {
    init() {    }
    
    mutating func replaceSubrange<C>(_ subrange: Range<Int>, with newElements: C) where C : Collection, SpringMap.Status == C.Element {
        self.elements.replaceSubrange(subrange, with: newElements)
    }
}

extension SpringStatusRow: Hashable {}
