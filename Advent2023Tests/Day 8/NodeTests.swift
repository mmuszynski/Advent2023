//
//  NodeTests.swift
//  Advent2023Tests
//
//  Created by Mike Muszynski on 12/10/23.
//

import XCTest
@testable import Advent2023

final class NodeTests: XCTestCase {

    func testInitNode() throws {
        let line = "AAA = (BBB, CCC)"
        let node = Node(line)
        XCTAssertEqual(node.name, "AAA")
        XCTAssertEqual(node.leftExit, "BBB")
        XCTAssertEqual(node.rightExit, "CCC")
    }

}
