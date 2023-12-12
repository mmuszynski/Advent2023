//
//  CamelCardSorting.swift
//  Advent2023Tests
//
//  Created by Mike Muszynski on 12/10/23.
//

import XCTest
@testable import Advent2023

final class CamelCardSorting: XCTestCase {
    
    func testMakeHand() throws {
        let fiveOfAKind: CamelCardsHand = "AAAAA"
        let fourOfAKind: CamelCardsHand = "KAAAA"
        let fullHouse32: CamelCardsHand = "23233"
        let fullHouse3A: CamelCardsHand = "2A2A2"
        let threeFours: CamelCardsHand = "AK444"
        let pair: CamelCardsHand = "84758"
        let twoPair: CamelCardsHand = "84458"
        let highCard: CamelCardsHand = "475KJ"

        XCTAssertEqual(fiveOfAKind.handType, .fiveOfAKind(card: .ace))
        XCTAssertEqual(fourOfAKind.handType, .fourOfAKind(card: .ace))
        XCTAssertEqual(fullHouse32.handType, .fullHouse(set: .three, pair: .two))
        XCTAssertEqual(fullHouse3A.handType, .fullHouse(set: .two, pair: .ace))
        XCTAssertEqual(threeFours.handType, .threeOfAKind(setOf: .four))
        XCTAssertEqual(pair.handType, .onePair(pairOf: .eight))
        XCTAssertEqual(twoPair.handType, .twoPair(lowPair: .four, highPair: .eight))
        XCTAssertEqual(highCard.handType, .highCard(card: .king))

    }

    func testSortCamelCards() throws {
        let ace = CamelCard.ace
        let ten = CamelCard.ten
        
        XCTAssertTrue(ace > ten)
    }
    
    func testCamelCardHandTypeSort() throws {
        let fiveAces = CamelCardsHand.HandType.fiveOfAKind(card: .ace)
        let fiveKings = CamelCardsHand.HandType.fiveOfAKind(card: .king)
        
        let acesOverKings = CamelCardsHand.HandType.fullHouse(set: .ace, pair: .king)
        let kingsOverAces = CamelCardsHand.HandType.fullHouse(set: .king, pair: .ace)
        
        XCTAssertTrue(fiveAces > fiveKings)
        XCTAssertTrue(fiveAces > kingsOverAces)
        XCTAssertFalse(kingsOverAces > fiveAces)
        XCTAssertTrue(acesOverKings > kingsOverAces)
        XCTAssertFalse(kingsOverAces > acesOverKings)
        XCTAssertEqual(acesOverKings, acesOverKings)
    }
    
    func testHandSort() throws {
        let fiveOfAKind: CamelCardsHand = "AAAAA"
        let fourOfAKind: CamelCardsHand = "KAAAA"
        let fourOfAKindButHigher: CamelCardsHand = "AKKKK"
        let lowpair: CamelCardsHand = "52342"
        let highpair: CamelCardsHand = "45532"
        
        XCTAssertTrue(fiveOfAKind > fourOfAKind)
        XCTAssertTrue(fourOfAKindButHigher > fourOfAKind)
        XCTAssertTrue(highpair < lowpair)
    }
    
    func testHandSortBadExample() throws {
        let first: CamelCardsHand = "KK677"
        let second: CamelCardsHand = "KTJJT"
        
        XCTAssertTrue(first > second)
    }
    
    func testSortCardRanks() throws {
        XCTAssertEqual(CamelCard.allCases.sorted(), [.two, .three, .four, .five, .six, .seven, .eight, .nine,  .ten, .jack, .queen, .king, .ace])
        
        CamelCards.usesJokers = true
        XCTAssertEqual(CamelCard.allCases.sorted(), [.jack, .two, .three, .four, .five, .six, .seven, .eight, .nine,  .ten, .queen, .king, .ace])
        CamelCards.usesJokers = false

    }
    
    func testJokersNotMakingPairs() throws {
        CamelCards.usesJokers = true
        let pairUsingJokers: CamelCardsHand = "J2A34"
        XCTAssertEqual(pairUsingJokers.handTypeNaive, .onePair)
        CamelCards.usesJokers = false
    }
    
    func testJokerIncorrectFullHouse() throws {
        CamelCards.usesJokers = true
        let fullHouse: CamelCardsHand = "J2K2T"
        XCTAssertNotEqual(fullHouse.handTypeNaive, .fullHouse)
        XCTAssertEqual(fullHouse.handTypeNaive, .threeOfAKind)
        CamelCards.usesJokers = false
    }
    
    func testJokerIncorrectFour() throws {
        CamelCards.usesJokers = true
        let four: CamelCardsHand = "8JJA9"
        XCTAssertNotEqual(four.handTypeNaive, .fourOfAKind)
        XCTAssertEqual(four.handTypeNaive, .threeOfAKind)
        CamelCards.usesJokers = false
    }

}
