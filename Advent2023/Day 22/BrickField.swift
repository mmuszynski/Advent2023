//
//  SandBrickController.swift
//  Advent2023
//
//  Created by Mike Muszynski on 1/21/24.
//

import Foundation
import Coordinate
import SwiftUI
import Graph

extension Coordinate {
    var atZeroHeight: Coordinate {
        var returnCoord = self
        returnCoord.z = 0
        return returnCoord
    }
}

struct BrickField: Equatable {
    init(bricks: Array<SandBrick>) {
        self.init(bricks: Set(bricks))
    }
    
    init(bricks: Set<SandBrick>) {
        self.bricks = bricks
        //self.coordinateCache = Set(bricks.map(\.coordinates).map(Array.init).reduce([], +))
        for brick in bricks {
            for coordinate in brick.coordinates {
                assert(!coordinateCache.contains(coordinate))
                coordinateCache.insert(coordinate)
            }
        }
    }
    
    var bricks: Set<SandBrick> = []
    var coordinateCache: Set<Coordinate> = []
    
    mutating func remove(bricks: Set<SandBrick>) {
        self.bricks.subtract(bricks)
        for brick in bricks {
            coordinateCache.subtract(brick.coordinates)
        }
    }
 
    func bricks(supportedBy other: SandBrick) -> Set<SandBrick> {
        //which bricks are directly above the given brick
        let above = Set(other.coordinates.map { $0 + "0,0,1" })
        return Set(self.bricks.filter {
            !above.isDisjoint(with: $0.coordinates) && $0 != other
        })
    }
    
    func canRemoveNaively(brick: SandBrick) -> Bool {
        var newBricks = self.bricks
        newBricks.remove(brick)
        let newField = BrickField(bricks: newBricks)
        return newField.bricks.first { $0.isFloating(in: newField) } == nil
    }
    
    func floatersAfterRemoving(brick: SandBrick) -> Set<SandBrick> {
        let aboveZ = brick.highestZ + 1
        let testBricks = bricks.filter { $0.coordinates.map(\.z).contains(aboveZ) }
        return testBricks.filter { $0.isFloating(in: self, ignoring: brick.coordinates)}
    }
    
    func canRemove(brick: SandBrick) -> Bool {
        floatersAfterRemoving(brick: brick).isEmpty
    }
    
    func settled() -> BrickField {
        //build topography
        var topography = [Coordinate: Int]()
        
        func printTopography() {
            var rows = [String]()
            for row in 0...2 {
                var rowString = ""
                for col in 0...2 {
                    let coord = Coordinate(row: row, col: col)
                    rowString += "\(topography[coord]!)"
                }
                rows.append(rowString)
            }
            print(rows.joined(separator: "\n"))
        }
        
        //get bricks sorted
        let bricks = self.bricks.sorted(by: { $0.lowestZ < $1.lowestZ })
        var newBricks = [SandBrick]()
        
        for brick in bricks {
            let min = (brick.coordinates.compactMap { topography[$0.atZeroHeight] }.max() ?? 0) + 1
            var newBrick = brick
            if newBrick.isVertical {
                if newBrick.start.z > newBrick.end.z { fatalError() }
                
                let height = newBrick.highestZ - newBrick.lowestZ
                newBrick.start.z = min
                newBrick.end.z = min + height
            } else {
                newBrick.start.z = min
                newBrick.end.z = min
            }
            
            newBricks.append(newBrick)
            
            for coordinate in newBrick.coordinates.sorted(by: { $0.z < $1.z }) {
                topography[coordinate.atZeroHeight] = coordinate.z
            }
        }
        
        return BrickField(bricks: newBricks)
    }
        
    func naivelySettled(steps: Int = 0, callback: ((SandBrick?, SandBrick?)->())? = nil) -> BrickField {
        var bricks = Array(bricks)
        var history: (SandBrick?, SandBrick?) = (nil, nil)
        
        var done = false
        let steps = steps == 0 ? .max : steps
        var stepsDone = 0
        
        while stepsDone < steps && !done {
            stepsDone += 1
            if let index = bricks.firstIndex(where: { $0.isFloating(in: BrickField(bricks: bricks)) }) {
                history.0 = bricks[index]
                bricks[index].move(down: 1)
                history.1 = bricks[index]
                callback?(history.0, history.1)
            } else {
                callback?(nil, nil)
                done = true
            }
        }
        
        return BrickField(bricks: bricks)
    }
    
    mutating func naiveSettle(steps: Int = 0, callback: ((SandBrick?, SandBrick?)->())? = nil) {
        self = self.naivelySettled(steps: steps, callback: callback)
    }
    
    func buildGraph() -> DirectionalGraph<SandBrick> {
        var graph = DirectionalGraph<SandBrick>()
        for brick in bricks {
            //get bricks supported
            for supported in bricks(supportedBy: brick) {
                graph.addEdge(from: brick, to: supported)
            }
        }
        
        return graph
    }
    
    func getFloaterCascade(from start: SandBrick) -> [SandBrick] {
        var field = self
        var floaters = field.floatersAfterRemoving(brick: start)
        var returnValue = [SandBrick]()
        while !floaters.isEmpty {
            field.remove(bricks: floaters)
            for floater in floaters {
                floaters.formUnion(field.floatersAfterRemoving(brick: floater))
                floaters.remove(floater)
                returnValue.append(floater)
            }
        }
        
        return returnValue
    }
}
