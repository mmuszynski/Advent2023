//
//  MatrixPrint.swift
//  Advent2023
//
//  Created by Mike Muszynski on 1/15/24.
//

import Foundation

extension Matrix2D {
    func print(rows rowSubrange: Range<Self.Index>, columns columnSubrange: Range<Self.RowElement.Index>) {
        var string = ""
        let rows = self[rowSubrange]
        for row in rows {
            var rowString = ""
            let col = row[columnSubrange]
            for element in col {
                rowString.append(String(describing: element))
            }
            string.append(rowString + "\r")
        }
        
        Swift.print(string)
    }
}
