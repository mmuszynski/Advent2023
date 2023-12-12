//
//  Day7.swift
//  Advent2023Tests
//
//  Created by Mike Muszynski on 12/10/23.
//

import XCTest
import BundleURL
@testable import Advent2023

extension Array where Element == CamelCardsBid {
    var value: Int {
        let value = self.enumerated().reduce(0) { partialResult, nextBid in
            let rank = nextBid.offset + 1
            let bid = nextBid.element.bid
            return partialResult + rank * bid
        }
        return value
    }
}

final class Day7: XCTestCase {
 
    func processBids(from string: String) -> [CamelCardsBid] {
        let bids = string.separatedByLine.map(CamelCardsBid.init).sorted { bid1, bid2 in
            bid1.hand < bid2.hand
        }
        return bids
    }
    
    
    
    func testDay7ExamplePart1() throws {
        let string = try String(contentsOf: .exampleDay7)
        XCTAssertEqual(processBids(from: string).value, 6440)
    }
    
    func testDay7InputPart1() throws {
        let string = try String(contentsOf: .inputDay7)
        XCTAssertEqual(processBids(from: string).value, 251121738)
    }
    
    func testDay7ExamplePart2() throws {
        CamelCards.usesJokers = true
        let string = try String(contentsOf: .exampleDay7)
        XCTAssertEqual(processBids(from: string).value, 5905)
        CamelCards.usesJokers = false
    }
    
    func testDay7InputPart2() throws {
        CamelCards.usesJokers = true
        let string = try String(contentsOf: #bundleURL("inputDay7")!)
        let bids = processBids(from: string)
        print(bids.map(\.hand))
        XCTAssertEqual(bids.value, 251421071)
        CamelCards.usesJokers = false
    }
    
}
