//
//  ScratchCard.swift
//  Advent2023
//
//  Created by Mike Muszynski on 12/6/23.
//

import Foundation

struct ScratchCard {
    public var targets: [Int]
    public var numbers: [Int]
    
    public init(string: String) {
        let comps = string
            .components(separatedBy: ":")[1]
            .components(separatedBy: "|")
        
        guard comps.count == 2 else { fatalError(string) }
        targets = comps[0].components(separatedBy: .whitespaces).compactMap { Int($0) }
        numbers = comps[1].components(separatedBy: .whitespaces).compactMap { Int($0) }
    }
    
    public var wins: Int {
        Set(targets).intersection(Set(numbers)).count
    }
    
    private func pow(_ base: Int, _ power: Int) -> Int {
        var result = 1
        for _ in 0..<power {
            result *= base
        }
        return result
    }
    
    public var score: Int {
        let wins = wins
        return wins == 0 ? 0 : pow(2, wins - 1)
    }
}
