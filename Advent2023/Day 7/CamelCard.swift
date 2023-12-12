//
//  CamelCard.swift
//  Advent2023
//
//  Created by Mike Muszynski on 12/10/23.
//

import Foundation

enum CamelCard: Character, CaseIterable {
    case two = "2"
    case three = "3"
    case four = "4"
    case five = "5"
    case six = "6"
    case seven = "7"
    case eight = "8"
    case nine = "9"
    case ten = "T"
    case jack = "J"
    case queen = "Q"
    case king = "K"
    case ace = "A"
    
    var description: String {
        String(rawValue)
    }
}

extension CamelCard: Comparable {
    static func < (lhs: CamelCard, rhs: CamelCard) -> Bool {
        var lhsIndex = CamelCard.allCases.firstIndex(of: lhs)!
        var rhsIndex = CamelCard.allCases.firstIndex(of: rhs)!
        
        if lhs == .jack && CamelCards.usesJokers {
            lhsIndex = -1
        }
        
        if rhs == .jack && CamelCards.usesJokers {
            rhsIndex = -1
        }
        
        return lhsIndex < rhsIndex
    }
}
