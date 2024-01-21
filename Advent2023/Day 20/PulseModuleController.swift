//
//  PulseModuleController.swift
//  Advent2023
//
//  Created by Mike Muszynski on 1/14/24.
//

import Foundation

typealias Command = (pulse: ModulePulse, destination: String, origin: String)

class PulseModuleController {
    var modules: [String: PulseModule] = [:]
    var commands: [Command] = []
    var debug: Bool = false
    
    var highPulses: Int = 0
    var lowPulses: Int = 0
    var presses: Int = 0
    
    var completed: Bool = false
    
    var listener: ((String, Int)->())?
    
    init() {}
    
    init(string: String) {
        for line in string.separatedByLine {
            let components = line.components(separatedBy: " -> ")
            
            if line.contains("broadcaster") {
                let name = components[0]
                let destinations = components[1].components(separatedBy: ", ")
                self.modules[name] = Broadcast(name: name, destinations: destinations)
            }
            
            if line.contains("%") {
                let name = components[0].replacingOccurrences(of: "%", with: "")
                let destinations = components[1].components(separatedBy: ", ")
                self.modules[name] = FlipFlop(name: name, destinations: destinations)
            }
            
            if line.contains("&") {
                let name = components[0].replacingOccurrences(of: "&", with: "")
                let destinations = components[1].components(separatedBy: ", ")
                self.modules[name] = Conjuction(name: name, inputs: [], destinations: destinations)
            }
        }
        
        for (key, module) in modules {
            if var module = module as? Conjuction {
                //find who points to it
                let inputs = ancestorsOfModule(named: module.name).map(\.name)
                for input in inputs {
                    module.add(input: input)
                }
                modules[key] = module
            }
        }
    }
    
    func ancestorsOfModule(named name: String) -> [PulseModule] {
        let inputs = modules.filter { $0.value.destinations.contains(name) }.map(\.value)
        return inputs
    }
    
    func send(_ pulse: ModulePulse, to module: String, from origin: String = "Button") {
        commands.append((pulse: pulse, destination: module, origin: origin))
        
        while !commands.isEmpty {
            let command = commands.removeFirst()
            
            let relevant = ["dr", "tr", "xm", "nh"]
            if relevant.contains(command.destination) && command.pulse == .low {
                listener?(command.destination, presses)
            }
            
            if debug {
                print("\(command.origin) \(command.pulse)> \(command.destination)")
            }
            
            let commandDestination = command.destination
            let pulse = command.pulse
            
            if pulse == .high {
                highPulses += 1
            } else {
                lowPulses += 1
            }
            
            var destinationObject = self.modules[commandDestination]
            
            let newCommands = destinationObject?.receive(pulse, from: command.origin) ?? []
            commands.append(contentsOf: newCommands)
            
            self.modules[commandDestination] = destinationObject
        }
    }
}
