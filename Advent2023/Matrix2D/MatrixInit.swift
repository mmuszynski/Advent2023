//
//  MatrixInit.swift
//  Advent2023
//
//  Created by Mike Muszynski on 12/13/23.
//

import Foundation

extension Matrix2D {
    init(string: String, lineConverter: (String) -> [Element]) {
        let lines = string.separatedByLine
        let rows = lines.map(lineConverter).map { RowElement($0) }
        self.init(rows)
    }
}
