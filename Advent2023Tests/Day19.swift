//
//  Day19.swift
//  Advent2023Tests
//
//  Created by Mike Muszynski on 12/19/23.
//

import XCTest
@testable import Advent2023
import BundleURL
import Graph

final class Day19: XCTestCase {
    
    let input = #bundleURL("inputDay19")!
    let example = #bundleURL("exampleDay19")!
 
    func testInstructionSet() {
        //px{a<2006:qkq,m>2090:A,rfg}
        let node = Day19InstructionNode(string: "px{a<2006:qkq,m>2090:A,rfg}")
        XCTAssertEqual(node.id, "px")
        
        let object = Day19Object(x: 0, m: 4000, a: 3000, s: 0)
        XCTAssertEqual(node.conditions.map({ $0.test(object: object) ? $0.passAction : nil}), [nil, .accept, .goto(id: "rfg")])
        
    }
    
    func testExample() throws {
        let string = try String(contentsOf: example)
        let parts = string.components(separatedBy: "\n\n")
        let instructions = parts[0].separatedByLine.map(Day19InstructionNode.init)
        let objects = parts[1].separatedByLine.map(Day19Object.init)
        
        let initial = instructions.first(where: { $0.id == "in" })!
        
        func test(object: Day19Object, against instruction: Day19InstructionNode) -> Bool {
            for condition in instruction.conditions {
                if condition.test(object: object) {
                    switch condition.passAction {
                    case .goto(id: let id):
                        let node = instructions.first(where: { $0.id == id })!
                        return test(object: object, against: node)
                    case .reject:
                        return false
                    case .accept:
                        return true
                    }
                } else {
                    continue
                }
            }
            fatalError()
        }
        
        var object = Day19Object(x: 4000, m: 838, a: 1716, s: 2770)
        XCTAssertTrue(test(object: object, against: initial))
        object = Day19Object(x: 4000, m: 838, a: 1716, s: 1351)
        XCTAssertTrue(test(object: object, against: initial))

        
        let accepted = objects.filter {
            test(object: $0, against: initial)
        }
        let value = accepted.reduce(0) { partialResult, object in
            partialResult + object.x + object.m + object.a + object.s
        }
        XCTAssertEqual(value, 19114)
    }
    
    func testInput() throws {
        let string = try String(contentsOf: input)
        let parts = string.components(separatedBy: "\n\n")
        let instructions = parts[0].separatedByLine.map(Day19InstructionNode.init)
        let objects = parts[1].separatedByLine.map(Day19Object.init)
        
        let initial = instructions.first(where: { $0.id == "in" })!
        
        func test(object: Day19Object, against instruction: Day19InstructionNode) -> Bool {
            for condition in instruction.conditions {
                if condition.test(object: object) {
                    switch condition.passAction {
                    case .goto(id: let id):
                        let node = instructions.first(where: { $0.id == id })!
                        return test(object: object, against: node)
                    case .reject:
                        return false
                    case .accept:
                        return true
                    }
                } else {
                    continue
                }
            }
            fatalError()
        }
        
        let accepted = objects.filter {
            test(object: $0, against: initial)
        }
        let value = accepted.reduce(0) { partialResult, object in
            partialResult + object.x + object.m + object.a + object.s
        }
        XCTAssertEqual(value, 398527)
    }
    
    func testRanges() throws {
        XCTAssertEqual(Day19RangedElement().clamped(to: 0..<1000, on: "x").x, 0..<1000)
        XCTAssertEqual(Day19RangedElement().clamped(to: 1000..<5000, on: "a").a, 1000..<4001)
    }
    
    func testIsEmpty() throws {
        XCTAssert(Day19RangedElement(x: 0..<0, m: 0..<0, a: 0..<0, s: 0..<0).isEmpty)
    }
    
    func process(state: Day19State, instructionSet: [Day19InstructionNode]) -> [Day19State] {
        //find the condition and come up with the up to two states that it produces
        
        //if the element has no empty ranges, there are no possible states
        if state.element.isEmpty {
            return []
        }
        
        //if the state is accepted, this represents the end of a path and the state can be returned
        if state.action == .accept {
            return [state]
        }
        
        //if the state is rejected, we don't care about it and can ignore it
        if state.action == .reject {
            return []
        }
        
        //if the state results in a goto, we need to recurse
        //note that this will also be the state for the initial node
        if case let .goto(id) = state.action {
            //find the next instruction by id
            //if there is no instruction set, we probably have a big mistake
            guard let instruction = instructionSet.first(where: { $0.id == id }) else { fatalError() }
            
            //now we need to run through the conditions to produce states to return
            var returnStates = [Day19State]()
            var element = state.element
            for condition in instruction.conditions {
                let passObject = element.clamped(to: condition.passRange, on: condition.variableName)
                let passState = Day19State(element: passObject, action: condition.passAction)
                returnStates.append(passState)
                
                let failObject = element.clamped(to: condition.failRange, on: condition.variableName)
                element = failObject
            }
            
            if !element.isEmpty {
                fatalError()
            }
            
            return Array(returnStates.map { process(state: $0, instructionSet: instructionSet) }.joined())
        }
        
        fatalError()
    }
    
    func testProcessStates() throws {
        let instructionSet = ["px{a<2006:R,m>2090:A,A}"].map(Day19InstructionNode.init)
        let initialState = Day19State(element: .init(), action: .goto(id: "px"))
        print(process(state: initialState, instructionSet: instructionSet))
    }
    
    func testExampleUsingRanges() throws {
        let string = try String(contentsOf: example)
        let parts = string.components(separatedBy: "\n\n")
        let instructions = parts[0].separatedByLine.map(Day19InstructionNode.init)
        let objects = parts[1].separatedByLine.map(Day19Object.init)
        
        let initialState = Day19State(element: .init(), action: .goto(id: "in"))
        let states = process(state: initialState, instructionSet: instructions)

        func objectPasses(_ object: Day19Object) -> Bool {
            let first = states.first { state in
                state.element.x.contains(object.x) &&
                state.element.m.contains(object.m) &&
                state.element.a.contains(object.a) &&
                state.element.s.contains(object.s)
            }
            return first != nil
        }
        
        let value = objects.filter(objectPasses(_:)).reduce(0) { partialResult, object in
            partialResult + object.x + object.m + object.a + object.s
        }
        
        XCTAssertEqual(value, 19114)
    }
    
    func testExamplePart2() throws {
        let string = try String(contentsOf: example)
        let parts = string.components(separatedBy: "\n\n")
        let instructions = parts[0].separatedByLine.map(Day19InstructionNode.init)
        
        let initialState = Day19State(element: .init(), action: .goto(id: "in"))
        let states = process(state: initialState, instructionSet: instructions)
        
        //combine states
        var distinctStateObjects: [Day19RangedElement] = []
        states.forEach { state in
            let object = state.element
            if let overlapping = distinctStateObjects.first(where: { other in
                !other.isDistinct(from: object)
            }) {
                print("non distinct object")
            } else {
                distinctStateObjects.append(object)
            }
        }
        
        let value = states.reduce(0) { partialResult, state in
            return partialResult +
            (state.element.x.count + (state.element.x.lowerBound == 0 ? 0 : 1) + (state.element.x.upperBound == 4000 ? 0 : -1)) *
            (state.element.m.count + (state.element.m.lowerBound == 0 ? 0 : 1) + (state.element.m.upperBound == 4000 ? 0 : -1)) *
            (state.element.a.count + (state.element.a.lowerBound == 0 ? 0 : 1) + (state.element.a.upperBound == 4000 ? 0 : -1)) *
            (state.element.s.count + (state.element.s.lowerBound == 0 ? 0 : 1) + (state.element.s.upperBound == 4000 ? 0 : -1))
        }
        
        XCTAssertEqual(value, 167409079868000)
    }
    
    func testInputPart2() throws {
        let string = try String(contentsOf: input)
        let parts = string.components(separatedBy: "\n\n")
        let instructions = parts[0].separatedByLine.map(Day19InstructionNode.init)
        
        let initialState = Day19State(element: .init(), action: .goto(id: "in"))
        let states = process(state: initialState, instructionSet: instructions)
        
        //combine states
        var distinctStateObjects: [Day19RangedElement] = []
        states.forEach { state in
            let object = state.element
            if let overlapping = distinctStateObjects.first(where: { other in
                !other.isDistinct(from: object)
            }) {
                print("non distinct object")
            } else {
                distinctStateObjects.append(object)
            }
        }
        
        let value = states.reduce(0) { partialResult, state in
            return partialResult +
            (state.element.x.count + (state.element.x.lowerBound == 0 ? 0 : 1) + (state.element.x.upperBound == 4000 ? 0 : -1)) *
            (state.element.m.count + (state.element.m.lowerBound == 0 ? 0 : 1) + (state.element.m.upperBound == 4000 ? 0 : -1)) *
            (state.element.a.count + (state.element.a.lowerBound == 0 ? 0 : 1) + (state.element.a.upperBound == 4000 ? 0 : -1)) *
            (state.element.s.count + (state.element.s.lowerBound == 0 ? 0 : 1) + (state.element.s.upperBound == 4000 ? 0 : -1))
        }
        
        XCTAssertEqual(value, 133973513090020)
    }
}
