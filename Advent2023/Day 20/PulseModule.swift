//
//  File.swift
//  Advent2023
//
//  Created by Mike Muszynski on 1/14/24.
//

import Foundation

protocol PulseModule {
    var name: String { get }
    var inputs: [String: ModulePulse] { get }
    var destinations: [String] { get }
    mutating func receive(_ pulse: ModulePulse, from: String) -> [Command]
}

extension PulseModule {
    var inputs: [String: ModulePulse] { [:] }
}

enum ModulePulse: CustomStringConvertible {
    case high
    case low
    
    var description: String {
        switch self {
        case .high:
            return "-high-"
        case .low:
            return "-low-"
        }
    }
}

//There is a single broadcast module (named broadcaster). When it receives a pulse, it sends the same pulse to all of its destination modules.
struct Broadcast: PulseModule {
    var name: String
    var destinations: [String]
    func receive(_ pulse: ModulePulse, from: String) -> [Command] {
        return destinations.map { (pulse: pulse, destination: $0, origin: self.name) }
    }
}

struct FlipFlop: PulseModule {
    var name: String
    var destinations: [String]
    //Flip-flop modules (prefix %) are either on or off; they are initially off. If a flip-flop module receives a high pulse, it is ignored and nothing happens. However, if a flip-flop module receives a low pulse, it flips between on and off. If it was off, it turns on and sends a high pulse. If it was on, it turns off and sends a low pulse.
    var isOn = false
    
    mutating func receive(_ pulse: ModulePulse, from: String) -> [Command] {
        if pulse == .high {
            return []
        } else {
            isOn.toggle()
            return destinations.map { (pulse: isOn ? .high : .low, destination: $0, origin: self.name) }
        }
    }
}

//Conjunction modules (prefix &) remember the type of the most recent pulse received from each of their connected input modules; they initially default to remembering a low pulse for each input. When a pulse is received, the conjunction module first updates its memory for that input. Then, if it remembers high pulses for all inputs, it sends a low pulse; otherwise, it sends a high pulse.
struct Conjuction: PulseModule {
    var name: String
    var inputs: [String: ModulePulse] = [:]
    var destinations: [String]
    
    mutating func receive(_ pulse: ModulePulse, from: String) -> [Command] {
        inputs[from] = pulse
        let output = inputs.values.allSatisfy { $0 == .high } ? ModulePulse.low : .high
        return destinations.map { destination in
            (pulse: output, destination: destination, origin: self.name)
        }
    }
    
    mutating func add(input name: String) {
        self.inputs[name] = .low
    }
    
    init(name: String, inputs: [String], destinations: [String]) {
        self.inputs = [:]
        for input in inputs {
            self.inputs[input] = .low
        }
        self.destinations = destinations
        self.name = name
    }
}

struct Output: PulseModule {
    var name: String = "Output"
    var inputs: [String: ModulePulse] = [:]
    var destinations: [String] = []
    mutating func receive(_ pulse: ModulePulse, from: String) -> [Command] {
        //print("Output: \(pulse)")
        return []
    }
}
