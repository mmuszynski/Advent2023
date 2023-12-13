//
//  MatrixRow.swift
//  Advent2023
//
//  Created by Mike Muszynski on 12/13/23.
//

import Foundation

/// The concrete rows for the data structure
struct MatrixRow<Element> {
    private var elements: Array<Element> = []
}

extension MatrixRow: RangeReplaceableCollection {
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
    mutating func replaceSubrange<C>(_ subrange: Range<Int>, with newElements: C) where C : Collection, Element == C.Element {
        self.elements.replaceSubrange(subrange, with: newElements)
    }
}

extension MatrixRow: ExpressibleByArrayLiteral {
    init(arrayLiteral: Element...) {
        self.init()
        for element in arrayLiteral {
            self.append(element)
        }
    }
}
