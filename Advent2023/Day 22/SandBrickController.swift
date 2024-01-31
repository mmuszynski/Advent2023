//
//  SandBrickController.swift
//  Advent2023
//
//  Created by Mike Muszynski on 1/26/24.
//

import Foundation
import Observation
import Coordinate
import SwiftUI
import GridVisualizer

struct BrickVisual {
    var color: Color?
    var highlightColor: Color?
}

@Observable
class SandBrickController {
    var brickField: BrickField
    var undoManager: UndoManager?
    var selection: SandBrick?
    
    init(url: URL) {
        let bricks = try! String(contentsOf: url).separatedByLine.map {
            var brick = SandBrick(string: $0)
            brick.color = .random
            return brick
        }
        brickField = BrickField(bricks: bricks)
    }
    
    var brickDisplay: [SandBrick] {
        brickField.bricks.sorted { one, two in
            if one.lowestZ == two.lowestZ {
                if one.start.x == two.start.x {
                    return one.start.y < two.start.y
                }
                return one.start.x < two.start.x
            }
            return one.lowestZ < two.lowestZ
        }
    }
    
    func displayColors() -> [Coordinate: BrickVisual] {
        var coords = [Coordinate: BrickVisual]()
        for brick in brickField.bricks {
            //let highlight = brick.isFloating(in: brickField) ? Color.accentColor : nil
            for coordinate in brick.coordinates {
                let visual = BrickVisual(color: brick.color ?? .black, highlightColor: selection == brick ? .accentColor : nil)
                coords[coordinate] = visual
            }
        }
        return coords
    }
    
    var steps: Array<String> = []
    func nextSettleStepNaive() {
        brickField.naiveSettle(steps: 1) { old, new in
            guard let old, let new else {
                self.steps.append("Done")
                return
            }
            self.steps.append("\(old.debugDescription) to \(new.debugDescription)")
        }
    }
    
    func naiveSettle() {
        brickField.naiveSettle() { old, new in
            guard let old, let new else {
                self.steps.append("Done")
                return
            }
            self.steps.append("\(old.debugDescription) to \(new.debugDescription)")
        }
    }
    
    func settle() {
        let old = self.brickField
        self.brickField = brickField.settled()
        self.steps.append("Settled")
        
        undoManager?.registerUndo(withTarget: self, handler: {
            $0.brickField = old
            $0.steps.removeLast()
        })
    }
}
