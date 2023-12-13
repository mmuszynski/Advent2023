//
//  MatrixColumn.swift
//  Advent2023
//
//  Created by Mike Muszynski on 12/13/23.
//

import Foundation

/// The computed rows for the matrix data structure
/// Hopefully readonly
struct MatrixColumn<Element> {
    private var elements: Array<Element> = []
    init(elements: Array<Element>) {
        self.elements = elements
    }
}

extension MatrixColumn: Collection {
    var startIndex: Array<Element>.Index { elements.startIndex }
    var endIndex: Array<Element>.Index { elements.endIndex }
    subscript(position: Int) -> Element {
        get {
            elements[position]
        }
    }
    func index(after i: Int) -> Array<Element>.Index {
        elements.index(after: i)
    }
}
