//
//  MatrixTests.swift
//  Advent2023Tests
//
//  Created by Mike Muszynski on 12/13/23.
//

import XCTest
@testable import Advent2023

final class HeapTests: XCTestCase {
    
    func testHeap() throws {
        var heap = Heap<Int>()
        heap.insert(item: 4)
        heap.insert(item: 5)
        heap.insert(item: 100)
        heap.insert(item: 1)
        
        XCTAssertEqual(heap.getTop(), 100)
        XCTAssertEqual(heap.count, 4)
        XCTAssertEqual(heap.popTop(), 100)
        XCTAssertEqual(heap.count, 3)
        XCTAssertEqual(heap.popTop(), 5)
    }
    
    func testMinHeap() throws {
        var heap = Heap<Int>(comparator: <)
        heap.insert(item: 4)
        heap.insert(item: 5)
        heap.insert(item: 100)
        heap.insert(item: 1)
        
        XCTAssertEqual(heap.getTop(), 1)
        XCTAssertEqual(heap.count, 4)
        XCTAssertEqual(heap.popTop(), 1)
        XCTAssertEqual(heap.count, 3)
        XCTAssertEqual(heap.popTop(), 4)
    }
    
}
