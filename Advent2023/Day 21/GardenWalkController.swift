//
//  GardenWalkController.swift
//  Advent2023
//
//  Created by Mike Muszynski on 1/15/24.
//

import Foundation
import Graph
import Coordinate
import GridVisualizer
import Observation
import Cocoa
import SwiftUI

enum GardenWalkTile {
    case rock
    case active
}

extension GardenWalkTile: GridDisplayable {
    public func draw(in rect: NSRect) {
        let path = NSBezierPath()
        NSGraphicsContext.current?.saveGraphicsState()
        
        switch self {
        case .rock:
            path.move(to: rect.origin)
            path.line(to: NSPoint(x: rect.maxX, y: rect.maxY))
            path.move(to: NSPoint(x: rect.minX, y: rect.maxY))
            path.line(to: NSPoint(x: rect.maxX, y: rect.minY))
            NSColor(Color.secondary.opacity(0.5)).setStroke()
        case .active:
            path.appendOval(in: rect.insetBy(dx: rect.size.width / 20, dy: rect.size.height / 20))
            NSColor(Color.accentColor).setStroke()
            NSColor(Color.accentColor.opacity(0.5)).setFill()
            path.fill()
            path.lineWidth = min(rect.width / 20, rect.height / 20)
        }
        
        path.stroke()
        NSGraphicsContext.current?.restoreGraphicsState()
    }
}

@Observable
class GardenWalkController {
    @ObservationIgnored var graph: DirectionalGraph<Coordinate>
    @ObservationIgnored let matrix: Matrix2D<Character>
    
    convenience init(url: URL) throws {
        let string = try String(contentsOf: url)
        self.init(string: string)
    }
    
    init(string: String) {
        graph = DirectionalGraph()
        matrix = Matrix2D(string: string) { $0.enumerated().map(\.element) }
    
        Task {
            self.isWorking = true
            await setupGraph()
            self.reset()
            self.isWorking = false
        }
    }
    
    var isWorking: Bool = false
    
    func reset() {
        self.hashes = CyclicalArray()
        self.activeLocations.removeAll()
        if let initialLocation { self.activeLocations.insert(initialLocation) }
        self.setElements()
    }
    
    var initialLocation: Coordinate?
    
    func setupGraph() async {
        for row in 0..<matrix.rowCount {
            for col in 0..<matrix.columnCount {
                let coordinate = Coordinate(row: row, col: col)
                let element = matrix.element(at: coordinate)
                guard element != "#" else {
                    rocks.append(coordinate)
                    continue
                }
                
                for direction in Coordinate.cardinalDirections {
                    let neighbor = coordinate + direction
                    guard let neighborElement = matrix.element(at: neighbor) else { continue }
                    guard neighborElement != "#" else {
                            continue
                    }

                    graph.addEdge(from: coordinate, to: neighbor)
                    if neighborElement == "S" {
                        initialLocation = neighbor
                    }
                }
            }
        }
        
        await MainActor.run {
            setElements()
        }
    }
    
    func setElements() {
        let active = Dictionary(uniqueKeysWithValues: activeLocations.map { ($0, GardenWalkTile.active) })
        let rocks = Dictionary(uniqueKeysWithValues: rocks.map { ($0, GardenWalkTile.rock) })
        elements = active.merging(rocks, uniquingKeysWith: { new, _ in
            new
        })
    }
    
    @ObservationIgnored var activeLocations: Set<Coordinate> = [] {
        didSet {
            setElements()
        }
    }
    
    var undoManager: UndoManager = UndoManager()
    
    func step(_ count: Int = 1) {
        for _ in 0..<count {
            let oldLocations = activeLocations
            let newLocations = Set(activeLocations.map { graph.neighbors(of: $0) }.joined())
            activeLocations = newLocations
            hashes.append(newLocations.hashValue)
            undoManager.registerUndo(withTarget: self) {
                $0.activeLocations = oldLocations
                $0.hashes.removeLast()
            }
        }
    }
    
    @ObservationIgnored var rocks: [Coordinate] = []
    var elements: [Coordinate : GridDisplayable] = [:]
    var elementHash: Int {
        self.activeLocations.hashValue
    }
    
    @ObservationIgnored var hashes: CyclicalArray<Int> = .init()
    
    func resolve(_ press: KeyPress) -> KeyPress.Result {
        let amount = press.modifiers.contains(.shift) ? 10 : 1
        
        switch press.key {
        case .rightArrow:
            self.activeLocations = Set(activeLocations.map { $0 + .right * amount })
        case .leftArrow:
            self.activeLocations = Set(activeLocations.map { $0 + .left * amount })
        case .downArrow:
            //swap down and up
            self.activeLocations = Set(activeLocations.map { $0 + .up * amount })
        case .upArrow:
            self.activeLocations = Set(activeLocations.map { $0 + .down * amount })
        case .return:
            for _ in 0..<amount {
                self.step()
            }
        default:
            return .ignored
        }
        
        setElements()
        return .handled
    }
    
    func runUntilCycle() {
        while hashes.cycleLength == 0 {
            step()
        }
    }
    
    var stepAdvanceNumber: Int = 1
}
