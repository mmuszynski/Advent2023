//
//  PulseModuleExamples.swift
//  Advent2023
//
//  Created by Mike Muszynski on 1/14/24.
//

import Foundation

extension PulseModuleController {
    static var example: PulseModuleController {
        let controller = PulseModuleController()
        controller.debug = true
        controller.modules["broadcaster"] = Broadcast(name: "broadcaster", destinations: ["a", "b", "c"])
        controller.modules["a"] = FlipFlop(name: "a", destinations: ["b"])
        controller.modules["b"] = FlipFlop(name: "b", destinations: ["c"])
        controller.modules["c"] = FlipFlop(name: "c", destinations: ["inv"])
        controller.modules["inv"] = Conjuction(name: "inv", inputs: ["c"], destinations: ["a"])
        return controller
    }
    
    static var example2: PulseModuleController {
        let controller = PulseModuleController()
        controller.debug = true
        controller.modules["broadcaster"] = Broadcast(name: "broadcaster", destinations: ["a"])
        controller.modules["a"] = FlipFlop(name: "a", destinations: ["inv", "con"])
        controller.modules["inv"] = Conjuction(name: "inv", inputs: ["a"], destinations: ["b"])
        controller.modules["b"] = FlipFlop(name: "b", destinations: ["con"])
        controller.modules["con"] = Conjuction(name: "con", inputs: ["a", "b"], destinations: ["output"])
        controller.modules["output"] = Output()
        return controller
    }
}
