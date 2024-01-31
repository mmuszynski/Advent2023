//
//  Day21.swift
//  Advent2023Tests
//
//  Created by Mike Muszynski on 1/15/24.
//

import XCTest
@testable import Advent2023
import BundleURL
import Coordinate

final class Day22: XCTestCase {
    
    let input = #bundleURL("inputDay22")!
    let example = #bundleURL("exampleDay22")!
 
    func testBrickInit() {
        let brick = SandBrick(string: "0,0,1~1,1,1")
        XCTAssertEqual(brick.volume, 4)
        let brick10 = SandBrick(string: "0,0,1~0,0,10")
        XCTAssertEqual(brick10.volume, 10)
    }
    
    func testBrickField() throws {
        let bricks: [SandBrick] = ["0,0,5~0,1,5"]
        var field = BrickField(bricks: bricks)
        field.naiveSettle()
        XCTAssertEqual(field.bricks.first, "0,0,1~0,1,1")
    }
    
    func testDisintigrate() throws {
        let bricks: [SandBrick] = ["0,0,5~0,1,5"]
        var field = BrickField(bricks: bricks)
        field.naiveSettle()
        XCTAssertTrue(field.canRemove(brick: field.bricks.first!))
        XCTAssertFalse(field.canRemove(brick: "0,0,0~0,1,0"))
    }
    
    func testFloater() throws {
        let bricks: [SandBrick] = ["0,0,5~0,1,5"]
        let field = BrickField(bricks: bricks)
        XCTAssertTrue(SandBrick(string: "0,0,5~0,1,5").isFloating(in: field))
    }
    
    func testNonFloater() throws {
        let bricks: [SandBrick] = ["0,0,5~0,1,5"]
        let field = BrickField(bricks: bricks)
        XCTAssertFalse(SandBrick(string: "0,0,1~0,1,1").isFloating(in: field))
        XCTAssertFalse(SandBrick(string: "0,0,6~0,1,6").isFloating(in: field))
        XCTAssertFalse(SandBrick(string: "0,1,6~0,2,6").isFloating(in: field))
    }
    
    func testFailedFloater() throws {
        let field = BrickField(bricks: [])
        XCTAssertTrue(SandBrick(string: "1,1,8~1,1,9").isFloating(in: field))
    }
    
    func testExample() throws {
        let bricks = try String(contentsOf: example).separatedByLine.map { SandBrick(string: $0) }
        var field = BrickField(bricks: bricks)
        field.naiveSettle()
        
        let floating = field.bricks.filter { $0.isFloating(in: field) }
        XCTAssertEqual(floating.count, 0)
  
//        Should be able to be removed
//        0,0,2~2,0,2   <- B
//        0,2,3~2,2,3   <- C
//        0,0,4~0,2,4   <- D
//        2,0,5~2,2,5   <- E
//        1,1,8~1,1,9   <- G
        
        XCTAssertTrue(field.canRemove(brick: "0,0,2~2,0,2"))
        XCTAssertTrue(field.canRemove(brick: "1,1,8~1,1,9"))
        
        let canRemove = field.bricks.filter { field.canRemove(brick: $0) }
        XCTAssertEqual(canRemove.count, 5)
    }
    
    func testNonNaive() throws {
        let bricks = try String(contentsOf: example).separatedByLine.map { SandBrick(string: $0) }
        let field = BrickField(bricks: bricks)
        let naive = field.naivelySettled()
        let smart = field.settled()
        
        XCTAssertEqual(naive, smart)
        
        let settledAgain = smart.settled()
        XCTAssertEqual(smart, settledAgain)
    }
    
    func testPart1() throws {
        let bricks = try String(contentsOf: input).separatedByLine.map { SandBrick(string: $0) }
        var field = BrickField(bricks: bricks)
        let settled = field.settled()
        
        let floating = settled.bricks.filter { $0.isFloating(in: settled) }
        XCTAssertEqual(floating.count, 0)
        
        let again = settled.settled()
        XCTAssertEqual(settled, again)
        
        XCTAssertTrue(settled.canRemove(brick: "6,9,4~8,9,4"))
        
        let can = settled.bricks.filter { settled.canRemove(brick: $0) }
        XCTAssertEqual(can.count, 475)
    }
    
    func testExamplePart2() throws {
        let bricks = try String(contentsOf: example).separatedByLine.map { SandBrick(string: $0) }
        let field = BrickField(bricks: bricks)
        let settled = field.settled()
        
        var count = 0
        for brick in settled.bricks {
            count += settled.getFloaterCascade(from: brick).count
        }
        
        
        XCTAssertEqual(count, 7)
    }
    
    func testSupport() throws {
        let bricks = try String(contentsOf: example).separatedByLine.map { SandBrick(string: $0) }
        let field = BrickField(bricks: bricks)
        let settled = field.settled()
        
        XCTAssertEqual(settled.bricks(supportedBy: "1,0,1~1,2,1"), ["0,0,2~2,0,2", "0,2,2~2,2,2"])
        XCTAssertEqual(settled.bricks(supportedBy: "0,0,2~2,0,2"), ["0,0,3~0,2,3", "2,0,3~2,2,3"])
        XCTAssertEqual(settled.bricks(supportedBy: "0,2,2~2,2,2"), ["0,0,3~0,2,3", "2,0,3~2,2,3"])
        XCTAssertEqual(settled.bricks(supportedBy: "0,0,3~0,2,3"), ["0,1,4~2,1,4"])
        XCTAssertEqual(settled.bricks(supportedBy: "2,0,3~2,2,3"), ["0,1,4~2,1,4"])
        XCTAssertEqual(settled.bricks(supportedBy: "0,1,4~2,1,4"), ["1,1,5~1,1,6"])
    }
    
    func testPart2() throws {
        #warning("This is correct but takes 263 seconds")
        let bricks = try String(contentsOf: input).separatedByLine.map { SandBrick(string: $0) }
        let field = BrickField(bricks: bricks)
        let settled = field.settled()
        
        var count = 0
        let settledBricks = Array(settled.bricks)
        for i in 0..<settledBricks.count {
            let brick = settledBricks[i]
            count += settled.getFloaterCascade(from: brick).count
            
            if i % 100 == 0 { print("\(i)") }
        }
        XCTAssertEqual(count, 79144)
    }
    
}
