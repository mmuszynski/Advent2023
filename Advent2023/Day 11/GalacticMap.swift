//
//  GalacticMap.swift
//  Advent2023
//
//  Created by Mike Muszynski on 12/12/23.
//

import Foundation

struct GalacticMap {
    enum GalacticContent {
        case empty
        case galaxy
    }
    
    var galaxies: [Coordinate] = []
    var map: [Coordinate: GalacticContent] = [:]
    
    init(string: String) {
        //get the lines
        let lines = string.separatedByLine
        var row = 0
        
        for line in lines {
            for (col, char) in line.enumerated() {
                switch char {
                case ".":
                    map[Coordinate(row: row, col: col)] = .empty
                case "#":
                    map[Coordinate(row: row, col: col)] = .galaxy
                default:
                    fatalError()
                }
            }
            
            row += 1
        }
    }
    
    func row(_ row: Int) -> [GalacticContent] {
        map.filter { $0.key.row == row }.sorted(by: { $0.key.x < $1.key.x }).map(\.value)
    }
    
    func column(_ column: Int) -> [GalacticContent] {
        map.filter { $0.key.col == column }.sorted(by: { $0.key.x < $1.key.x }).map(\.value)
    }
    
}
