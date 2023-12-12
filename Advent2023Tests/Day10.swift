//
//  Day10.swift
//  Advent2023Tests
//
//  Created by Mike Muszynski on 12/11/23.
//

import XCTest
import BundleURL
@testable import Advent2023

final class Day10: XCTestCase {

    let input = #bundleURL("inputDay10")!
    let example = #bundleURL("exampleDay10")!

    func testExampleDay10() throws {
        let string = try String(contentsOf: example)
        let map = PipeMap(string: string)
        
        XCTAssertEqual(map.determineSegment(at: "1,1"), [.bottom, .right])
    }
    
}
