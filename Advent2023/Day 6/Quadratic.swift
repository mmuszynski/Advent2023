//
//  Quadratic.swift
//  Advent2023
//
//  Created by Mike Muszynski on 12/9/23.
//

import Foundation

struct Quadratic {
    var a: Double
    var b: Double
    var c: Double
    
    var solutions: [Double] {
        [(-b + sqrt(b * b - 4 * a * c)) / (2 * a),
         (-b - sqrt(b * b - 4 * a * c)) / (2 * a)]
    }
}
