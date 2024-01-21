//
//  ReflectorGraph.swift
//  Advent2023
//
//  Created by Mike Muszynski on 1/13/24.
//

import Foundation
import Graph
import Coordinate

struct Reflector: Hashable {
    var type: ReflectorType
    var location: Coordinate
}

extension Reflector {
    static func rowAscending(_ first: Self, _ second: Self) -> Bool {
        return first.location.row < second.location.row
    }
    static func rowDescending(_ first: Self, _ second: Self) -> Bool {
        return first.location.row > second.location.row
    }
    static func columnAscending(_ first: Self, _ second: Self) -> Bool {
        return first.location.col < second.location.col
    }
    static func columnDescending(_ first: Self, _ second: Self) -> Bool {
        return first.location.col > second.location.col
    }
}

class ReflectorGraphController {
    
    var reflectors: [Reflector] = []
    var graph: DirectionalGraph<LightPulse>
    
    var columnCount = 0
    var rowCount = 0
    
    init(string: String) {
        for (row, line) in string.separatedByLine.enumerated() {
            for (col, element) in line.enumerated() {
                if element != "." {
                    let reflector = Reflector(type: .init(rawValue: element)!,
                                              location: Coordinate(row: row, col: col))
                    reflectors.append(reflector)
                }
                columnCount = col
            }
            rowCount = row
        }
        
        graph = DirectionalGraph()
        for reflector in reflectors {
            for direction in Coordinate.cardinalDirections {
                let currentState = LightPulse(moving: direction, location: reflector.location)
                for nextState in nextStates(from: currentState) {
                    graph.addEdge(from: currentState, to: nextState)
                }
            }
        }
    }
    
    func nextStates(from state: LightPulse) -> [LightPulse] {
        var states: [LightPulse] = []
        if let nextElement = nextElement(from: state.location, moving: state.moving) {
            let nextStates = nextStates(entering: nextElement, moving: state.moving)
            states.append(contentsOf: nextStates)
        } else {
            //the next state won't hit any reflectors
            //figure out the edge we are going to
            var exit = state.location
            switch state.moving {
            case .left:
                exit.col = -1
            case .right:
                exit.col = self.columnCount
            case .up:
                exit.row = -1
            case .down:
                exit.row = self.rowCount
            default:
                return []
            }
            states.append(LightPulse(moving: state.moving, location: exit))
        }
        return states
    }
    
    func nextStates(entering reflector: Reflector, moving direction: Coordinate) -> [LightPulse] {
        let nextDirections = reflector.type.nextDirectionsMoving(direction)
        let next = nextDirections.map { direction in
            LightPulse(moving: direction, location: reflector.location)
        }
        return next
    }
    
    func nextElement(from coordinate: Coordinate, moving direction: Coordinate) -> Reflector? {
        switch direction {
        case .right:
            return reflectors.filter({ $0.location.row == coordinate.row && $0.location.col > coordinate.col }).sorted(by: Reflector.columnAscending).first
        case .left:
            return reflectors.filter({ $0.location.row == coordinate.row && $0.location.col < coordinate.col }).sorted(by: Reflector.columnDescending).first
        case .up:
            return reflectors.filter({ $0.location.col == coordinate.col && $0.location.row < coordinate.row }).sorted(by: Reflector.rowDescending).first
        case .down:
            return reflectors.filter({ $0.location.col == coordinate.col && $0.location.row > coordinate.row }).sorted(by: Reflector.rowAscending).first
        default:
            break
        }
        return nil
    }
    
    func findCycles(from target: LightPulse) -> [[LightPulse]] {
        var stack = [LightPulse]()
        var visited = Set<LightPulse>()
        var cycles = [[LightPulse]]()
        var cameFrom = [LightPulse : LightPulse]()
        
        func buildCycle(to final: LightPulse, from initial: LightPulse) -> [LightPulse] {
            var path: [LightPulse] = []
            var current = final
            path.append(current)
            while current != initial, let next = cameFrom[current] {
                current = next
                path.append(current)
            }
            return path
        }
                
//         public List<List<Vertex>> getCyclesContainingVertex(int targetId) {
//                 Vertex target = vertexById.get(targetId);
//                 
//                 if (vertexById.get(targetId) == null) {
//                     return Collections.emptyList();
//                 }
//                 List<List<Vertex>> cycles = new ArrayList<>();
//                 
//                 Deque<Vertex> stack = new ArrayDeque<>();
//                 Set<Vertex> seen = new HashSet<>();
//                 Map<Vertex, Vertex> paths = new HashMap<>();
//                 
//                 stack.add(target);
        stack.append(target)
        while let current = stack.popLast() {
            visited.insert(current)
            for neighbor in graph.neighbors(of: current) {
                if visited.contains(neighbor) {
                    //cycle found, build cycle
                    cycles.append(buildCycle(to: neighbor, from: target))
                } else if !visited.contains(neighbor) {
                    stack.append(neighbor)
                    cameFrom[neighbor] = current
                    visited.insert(neighbor)
                }
            }
        }
        
        return cycles
//                 while (!stack.isEmpty()) {
//                     Vertex current = stack.pop();
//                     seen.add(current);
//                     for (Vertex neighbour : current.getNeighbours()) {
//                         if (seen.contains(neighbour) && neighbour.equals(target)) { // the cycle was found
//                             // build cycle, don't add vertex to the stack and don't add new entry to the paths (it can prevent other cycles containing neighbour vertex from being detected)
//                             cycles.add(buildCycle(paths, neighbour, current));
//                         } else if (!seen.contains(neighbour)) {
//                             stack.add(neighbour);
//                             paths.put(neighbour, current);
//                             seen.add(neighbour);
//                         }
//                     }
//                 }
//                 return cycles;
//             }
        
    }
}
