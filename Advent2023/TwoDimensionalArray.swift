//
//  TwoDimensionalArray.swift
//  Advent2023
//
//  Created by Mike Muszynski on 12/12/23.
//

import Foundation

/// Enough problems in the AdventOfCode2023 have required a two-dimensional map
/// Seems like it might be useful in the future
///
/// So here's an implementation of a 2D Matrix.
///
///
struct Matrix2D<Element> {
    typealias RowElement = MatrixRow<Element>
    private var rows: Array<RowElement>
}

/// Collection Conformance
extension Matrix2D: Collection {
    var startIndex: Array<RowElement>.Index { rows.startIndex }
    var endIndex: Array<RowElement>.Index { rows.endIndex }
    subscript(position: Int) -> RowElement {
        rows[position]
    }
    func index(after i: Int) -> Array<RowElement>.Index {
        rows.index(after: i)
    }
}

/// The concrete rows for the data structure
struct MatrixRow<Element> {
    private var elements: Array<Element>
}

extension MatrixRow: Collection {
    var startIndex: Array<Element>.Index { elements.startIndex }
    var endIndex: Array<Element>.Index { elements.endIndex }
    subscript(position: Int) -> Element {
        get {
            elements[position]
        }
        set {
            elements[position] = newValue
        }
    }
    func index(after i: Int) -> Array<Element>.Index {
        elements.index(after: i)
    }
}
