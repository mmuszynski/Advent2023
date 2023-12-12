//: [Previous](@previous)

import Foundation
import RegexBuilder

let sample = """
Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
"""

let lines = sample.components(separatedBy: .newlines)
let rawGames = lines.compactMap { $0.components(separatedBy: ": ").last }
let sampleGames = rawGames.map(Game.init)
let power = sampleGames.map(\.minimum)
    .map({ $0.red * $0.green * $0.blue })
    .sum

struct Game {
    var rounds: [RGBTriple] = []
    init(description: String) {
        self.rounds = description.components(separatedBy: "; ").map(RGBTriple.init)
    }
    
    func canSatisfy(red: Int, green: Int, blue: Int) -> Bool {
        return rounds.reduce(true) { partial, round in
            print(round)
            print(round.canSatisfy(red: red, green: green, blue: blue))
            
            return partial && round.canSatisfy(red: red, green: green, blue: blue)
        }
    }
    
    var minimum: RGBTriple {
        let red = self.rounds.map(\.red).max() ?? 0
        let green = self.rounds.map(\.green).max() ?? 0
        let blue = self.rounds.map(\.blue).max() ?? 0
        
        return RGBTriple(red: red, green: green, blue: blue)
    }
}

struct RGBTriple {
    var red: Int = 0
    var green: Int = 0
    var blue: Int = 0
    
    init(description: String) {
        let parts = description.components(separatedBy: ", ")
        for part in parts {
            if part.contains("red") {
                self.red = Int(part.replacingOccurrences(of: " red", with: "")) ?? 0
            }
            if part.contains("green") {
                self.green = Int(part.replacingOccurrences(of: " green", with: "")) ?? 0
            }
            if part.contains("blue") {
                self.blue = Int(part.replacingOccurrences(of: " blue", with: "")) ?? 0
            }
        }
    }
    
    init(red: Int, green: Int, blue: Int) {
        self.red = red
        self.green = green
        self.blue = blue
    }
    
    func canSatisfy(red: Int, green: Int, blue: Int) -> Bool {
        self.red <= red && self.green <= green && self.blue <= blue
    }
    
    var power: Int {
        red * green * blue
    }
}

let input = try String(contentsOf: #fileLiteral(resourceName: "Page2Input")).components(separatedBy: .newlines).filter { $0 != "" }
let inputLines = input.compactMap { $0.components(separatedBy: ": ").last }

//inputLines.map(Game.init).enumerated().compactMap {
//    if $0.element.canSatisfy(red: 12, green: 13, blue: 14) { return $0.offset + 1 }
//    return nil
//}.sum
//
//sampleGames.enumerated().compactMap {
//    if $0.element.canSatisfy(red: 12, green: 13, blue: 14) { return $0.offset + 1 }
//    return nil
//}.sum

inputLines.map(Game.init).map(\.minimum).map(\.power).sum




//: [Next](@next)
