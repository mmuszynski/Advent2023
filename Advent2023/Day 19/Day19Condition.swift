//
//  Day19Condition.swift
//  Advent2023
//
//  Created by Mike Muszynski on 1/8/24.
//

import Foundation

struct Day19Object {
    var x: Int
    var m: Int
    var a: Int
    var s: Int
    
    init(x: Int, m: Int, a: Int, s: Int) {
        self.x = x
        self.m = m
        self.a = a
        self.s = s
    }
    
    init(string: String) {
        let parts = string.components(separatedBy: ",").map {
            $0
                .replacingOccurrences(of: "{", with: "")
                .replacingOccurrences(of: "}", with: "")
                .replacingOccurrences(of: "x", with: "")
                .replacingOccurrences(of: "m", with: "")
                .replacingOccurrences(of: "a", with: "")
                .replacingOccurrences(of: "s", with: "")
                .replacingOccurrences(of: "=", with: "")
        }.compactMap(Int.init)
        
        self.x = parts[0]
        self.m = parts[1]
        self.a = parts[2]
        self.s = parts[3]
    }
    
    func value(for string: String) -> Int {
        switch string {
        case "a":
            return a
        case "m":
            return m
        case "x":
            return x
        case "s":
            return s
        default:
            fatalError()
        }
    }
}

extension String {
    func canProduce(_ action: Day19Condition.Action) -> Bool {
        switch action {
        case .goto(id: let id):
            return self.contains(":" + id)
        case .reject:
            return self.contains("R")
        case .accept:
            return self.contains("A")
        }
    }
}

struct Day19Condition {
    enum Action: Equatable {
        case goto(id: String)
        case reject
        case accept
        
        init(with string: String) {
            if string == "A" {
                self = .accept
            } else if string == "R" {
                self = .reject
            } else {
                self = .goto(id: string)
            }
        }
    }
    
    var variableName: String
    var passRange: Range<Int> = 0..<1
    var failRange: Range<Int> = 0..<1
    var string: String
    var passAction: Action
    
    init(string: String) {
        self.string = string
        variableName = ""
        
        if string.contains(":") {
            let colonSeparated = string.components(separatedBy: ":")
            let condition = colonSeparated[0]
            let target = colonSeparated[1]
            
            if condition.contains("<") {
                let conditionParts = condition.components(separatedBy: "<")
                variableName = conditionParts[0]
                guard let value = Int(conditionParts[1]) else { fatalError() }
                passRange = 0..<value
                failRange = value..<4000+1
            } else if condition.contains(">") {
                let conditionParts = condition.components(separatedBy: ">")
                variableName = conditionParts[0]
                guard let value = Int(conditionParts[1]) else { fatalError() }
                failRange = 0..<value+1
                passRange = value+1..<4000+1
            }
            
            passAction = Action(with: target)
        } else {
            passRange = 0..<4000+1
            failRange = 4001..<4001
            passAction = Action(with: string)
        }
    }
    
    func test(object: Day19Object) -> Bool {
        switch self.variableName {
        case "x":
            return passRange.contains(object.x)
        case "m":
            return passRange.contains(object.m)
        case "a":
            return passRange.contains(object.a)
        case "s":
            return passRange.contains(object.s)
        default:
            break
        }
        
        return true
    }
}

struct Day19InstructionNode {
    var id: String
    var conditions: [Day19Condition]
    var rawString: String
    
    init(string: String) {
        self.rawString = string
        //px{a<2006:qkq,m>2090:A,rfg}
        let parts = string.replacingOccurrences(of: "{", with: "***").replacingOccurrences(of: "}", with: "").components(separatedBy: "***")
        self.id = parts[0]
        let conditions = parts[1].components(separatedBy: ",")
        self.conditions = conditions.map(Day19Condition.init)
    }
}

class Day19Controller {
    var instructionNodes: [String: Day19InstructionNode] = [:]
    var objects: [Day19Object] = []
}
