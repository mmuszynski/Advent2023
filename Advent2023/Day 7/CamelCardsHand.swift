//
//  CamelCardsHand.swift
//  Advent2023
//
//  Created by Mike Muszynski on 12/10/23.
//

import Foundation

enum CamelCards {
    static var usesJokers: Bool = false
}

struct CamelCardsHand {
    let cards: [CamelCard]
    let handType: HandType
    let handTypeNaive: NaiveHandType
    
    enum HandSorting {
        case naive
        case common
    }
    
    static var handSorting: HandSorting = .naive
    
    enum NaiveHandType: Comparable {
        case highCard
        case onePair
        case twoPair
        case threeOfAKind
        case fullHouse
        case fourOfAKind
        case fiveOfAKind
    }

    enum HandType: Comparable {
        case highCard(card: CamelCard)
        case onePair(pairOf: CamelCard)
        case twoPair(lowPair: CamelCard, highPair: CamelCard)
        case threeOfAKind(setOf: CamelCard)
        case fullHouse(set: CamelCard, pair: CamelCard)
        case fourOfAKind(card: CamelCard)
        case fiveOfAKind(card: CamelCard)
    }
}

extension CamelCardsHand: ExpressibleByStringLiteral {
    init(stringLiteral value: StringLiteralType) {
        var cards = [CamelCard]()
        for char in value {
            cards.append(CamelCard(rawValue: char)!)
        }
        
        if cards.count != 5 {
            fatalError()
        }
        
        self.cards = cards
        
        //evaluate the handtype
        var handType: HandType = .highCard(card: .six)
        var handTypeNaive: NaiveHandType = .highCard
        
        var cardNums: [CamelCard: Int] = [:]
        for card in CamelCard.allCases {
            let count = self.cards.filter { $0 == card }.count
            cardNums[card] = count
        }
        
        var jokers = CamelCards.usesJokers ? (cardNums[.jack] ?? 0) : 0
        if CamelCards.usesJokers {
            cardNums[.jack] = 0
        }
        
        if let five = cardNums.filter({ $0.value + jokers == 5 }).first {
            handType = .fiveOfAKind(card: five.key)
            handTypeNaive = .fiveOfAKind
        } else if let four = cardNums.filter({ $0.value + jokers == 4 }).first {
            handType = .fourOfAKind(card: four.key)
            handTypeNaive = .fourOfAKind
        } else if let three = cardNums.filter({ $0.value + jokers == 3 }).first {
            jokers -= 3 - three.value
            cardNums[three.key] = 0
            if let two = cardNums.filter({ $0.value + jokers == 2 }).first {
                handType = .fullHouse(set: three.key, pair: two.key)
                handTypeNaive = .fullHouse
            } else {
                handType = .threeOfAKind(setOf: three.key)
                handTypeNaive = .threeOfAKind
            }
        } else {
            let two = cardNums.filter({ $0.value + jokers == 2 })
            if two.count > 2 {
                //this should only happen with jokers!
                handType = .onePair(pairOf: two.sorted { $0.key > $1.key }.first!.key)
                handTypeNaive = .onePair
            } else if two.count == 2 {
                if jokers != 0 { fatalError("This should not be possible with jokers") }
                
                let two = two.map { $0.key }.sorted()
                handType = .twoPair(lowPair: two[0], highPair: two[1])
                handTypeNaive = .twoPair
            } else if two.count == 1 {
                handType = .onePair(pairOf: two.first!.key)
                handTypeNaive = .onePair
            } else {
                handType = .highCard(card: self.cards.sorted().last!)
                handTypeNaive = .highCard
            }
        }
        
        self.handTypeNaive = handTypeNaive
        self.handType = handType
        
    }
    
}

extension CamelCardsHand: Comparable {
    static func < (lhs: CamelCardsHand, rhs: CamelCardsHand) -> Bool {
        if CamelCardsHand.handSorting == .naive {
            return CamelCardsHand.naiveSort(lhs: lhs, rhs: rhs)
        } else {
            return CamelCardsHand.commonSort(lhs: lhs, rhs: rhs)
        }
    }
    
    static func naiveSort(lhs: CamelCardsHand, rhs: CamelCardsHand) -> Bool {
        if lhs.handTypeNaive < rhs.handTypeNaive {
            return true
        } else if lhs.handTypeNaive == rhs.handTypeNaive {
            var lhsCards = Array(lhs.cards.reversed())
            var rhsCards = Array(rhs.cards.reversed())
            while let lhsCard = lhsCards.popLast(),
                  let rhsCard = rhsCards.popLast() {
                if lhsCard == rhsCard { continue }
                return lhsCard < rhsCard
            }
            return false
        }
        
        return false
    }
    
    static func commonSort(lhs: CamelCardsHand, rhs: CamelCardsHand) -> Bool {
        if lhs.handType < rhs.handType {
            return true
        } else if lhs.handType == rhs.handType {
            return lhs.cards.first! > rhs.cards.first!
        }
        
        return false
    }
    
    
}

extension CamelCardsHand: CustomStringConvertible {
    var description: String {
        self.cards.map(\.rawValue).reduce("") { $0 + String($1) }
    }
}
