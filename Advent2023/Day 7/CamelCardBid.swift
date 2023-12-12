//
//  CamelCardBid.swift
//  Advent2023
//
//  Created by Mike Muszynski on 12/10/23.
//

import Foundation

struct CamelCardsBid {
    var hand: CamelCardsHand
    var bid: Int
    
    init(string: String) {
        let comps = string.components(separatedBy: .whitespaces)
        self.hand = CamelCardsHand(stringLiteral: comps[0])
        self.bid = Int(comps[1])!
    }
}
